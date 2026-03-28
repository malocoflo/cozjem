from google import genai
from google.genai import types
from ..config import get_settings
from ..models.schemas import FridgeAnalysisResponse, Ingredient
import json
import logging

logger = logging.getLogger(__name__)

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
    client = _get_client()
    image_part = types.Part.from_bytes(data=image_data, mime_type=mime_type)
    try:
        response = client.models.generate_content(
            model="gemini-1.5-flash",
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
    except Exception as e:
        logger.error("Gemini API error: %s", e)
        raise
