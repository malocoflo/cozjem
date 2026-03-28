from google import genai
from google.genai.errors import ClientError
from google.genai import types
from ..config import get_settings
from ..models.schemas import FridgeAnalysisResponse, Ingredient, RecipeSuggestion, RecipeSuggestionsResponse
import json
import logging

logger = logging.getLogger(__name__)


class GeminiServiceError(Exception):
    def __init__(self, status_code: int, message: str):
        self.status_code = status_code
        self.message = message
        super().__init__(message)

PROMPT = (
    "Zidentyfikuj składniki na zdjęciu lodówki. "
    "Zwróć dane WYŁĄCZNIE jako JSON w formacie: "
    '{"ingredients": [{"name": str, "category": str, "confidence": str}]}. '
    "Użyj języka polskiego dla nazw produktów."
)


def _get_client() -> genai.Client:
    settings = get_settings()
    return genai.Client(api_key=settings.gemini_api_key)


async def analyze_fridge_image(image_data: bytes, mime_type: str) -> FridgeAnalysisResponse:
    settings = get_settings()
    client = _get_client()
    image_part = types.Part.from_bytes(data=image_data, mime_type=mime_type)
    try:
        response = client.models.generate_content(
            model=settings.gemini_model,
            contents=[PROMPT, image_part],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )
        raw = response.text
        data = json.loads(raw)
        ingredients = [Ingredient(**item) for item in data.get("ingredients", [])]
        return FridgeAnalysisResponse(ingredients=ingredients)
    except json.JSONDecodeError as e:
        logger.error("Failed to parse Gemini response as JSON: %s", e)
        raise ValueError("Invalid JSON response from Gemini API")
    except ClientError as e:
        status_code = int(getattr(e, "code", 503) or 503)
        logger.error("Gemini client error (%s): %s", status_code, e)

        if status_code == 429:
            raise GeminiServiceError(
                status_code=429,
                message="AI quota exceeded. Check Gemini plan/billing and limits.",
            )
        if status_code in (401, 403):
            raise GeminiServiceError(
                status_code=status_code,
                message="Invalid or unauthorized Gemini API key.",
            )
        if status_code == 404:
            raise GeminiServiceError(
                status_code=502,
                message="Configured Gemini model is not available.",
            )

        raise GeminiServiceError(
            status_code=503,
            message="AI service temporarily unavailable.",
        )
    except Exception as e:
        logger.error("Gemini API error: %s", e)
        raise


RECIPE_PROMPT = (
    "Na podstawie poniższej listy składników zaproponuj 4-6 ISTNIEJĄCYCH przepisów kulinarnych, "
    "które można przygotować z tych lub podobnych składników. "
    "Używaj polskich nazw przepisów. "
    "Zwróć dane WYŁĄCZNIE jako JSON w formacie: "
    '{{"recipes": [{{"title": str, "description": str, "duration_minutes": int, "tags": [str], '
    '"matched_ingredients": int, "total_ingredients": int, "required_ingredients": [str], '
    '"all_ingredients_available": bool}}]}}. '
    "description to max 90 znaków po polsku. "
    "matched_ingredients to liczba składników z listy pasujących do przepisu. "
    "total_ingredients to łączna liczba składników wymaganych przez przepis. "
    "required_ingredients to krótka lista podstawowych składników przepisu po polsku. "
    "all_ingredients_available = true tylko jeśli WSZYSTKIE required_ingredients są na liście wejściowej. "
    "Jeśli da się ułożyć przepisy w pełni z podanych składników, uwzględnij co najmniej 2 takie przepisy. "
    "tags to lista tagów np. ['#wege', '#fit', '#szybkie']. "
    "Składniki: {ingredients}"
)


def _normalize_name(value: str) -> str:
    return value.strip().lower()


def _is_recipe_fully_available(recipe: RecipeSuggestion, available: set[str]) -> bool:
    if recipe.required_ingredients:
        required = {_normalize_name(name) for name in recipe.required_ingredients if name.strip()}
        if required:
            return required.issubset(available)

    return recipe.matched_ingredients >= recipe.total_ingredients


async def suggest_recipes(ingredients: list[str]) -> RecipeSuggestionsResponse:
    settings = get_settings()
    client = _get_client()
    prompt = RECIPE_PROMPT.format(ingredients=", ".join(ingredients))
    try:
        response = client.models.generate_content(
            model=settings.gemini_model,
            contents=[prompt],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )
        raw = response.text
        data = json.loads(raw)
        parsed = [RecipeSuggestion(**item) for item in data.get("recipes", [])]
        available = {_normalize_name(name) for name in ingredients if name.strip()}
        recipes = [
            recipe.model_copy(
                update={
                    "all_ingredients_available": _is_recipe_fully_available(recipe, available)
                }
            )
            for recipe in parsed
        ]
        return RecipeSuggestionsResponse(recipes=recipes)
    except json.JSONDecodeError as e:
        logger.error("Failed to parse Gemini recipe response: %s", e)
        raise ValueError("Invalid JSON response from Gemini recipes API")
    except ClientError as e:
        status_code = int(getattr(e, "code", 503) or 503)
        logger.error("Gemini client error (%s) in suggest_recipes: %s", status_code, e)
        if status_code == 429:
            raise GeminiServiceError(
                status_code=429,
                message="AI quota exceeded. Check Gemini plan/billing and limits.",
            )
        if status_code in (401, 403):
            raise GeminiServiceError(
                status_code=status_code,
                message="Invalid or unauthorized Gemini API key.",
            )
        raise GeminiServiceError(
            status_code=503,
            message="AI service temporarily unavailable.",
        )
    except Exception as e:
        logger.error("Gemini suggest_recipes error: %s", e)
        raise
