import google.generativeai as genai
from ..config import get_settings
from ..models.schemas import FridgeAnalysisResponse, Ingredient
import json
import logging

logger = logging.getLogger(__name__)

PROMPT = (
    "Zidentyfikuj składniki na zdjęciu lodówki. "
    "Zwróć dane WYŁĄCZNIE jako JSON w formacie: "
    '{\"ingredients\": [{\"name\": str, \"category\": str, \"confidence\": str}]}. '
    "Użyj języka polskiego dla nazw produktów."
)


def get_gemini_model():
    settings = get_settings()
    genai.configure(api_key=settings.gemini_api_key)
    return genai.GenerativeModel(
        model_name="gemini-1.5-flash",
        generation_config={"response_mime_type": "application/json"},
    )


async def analyze_fridge_image(image_data: bytes, mime_type: str) -> FridgeAnalysisResponse:
    model = get_gemini_model()
    image_part = {"mime_type": mime_type, "data": image_data}
    try:
        response = model.generate_content([PROMPT, image_part])
        raw = response.text
        data = json.loads(raw)
        ingredients = [Ingredient(**item) for item in data.get("ingredients", [])]
        return FridgeAnalysisResponse(ingredients=ingredients)
    except json.JSONDecodeError as e:
        logger.error("Failed to parse Gemini response as JSON: %s", e)
        raise ValueError(f"Invalid JSON response from Gemini: {e}")
    except Exception as e:
        logger.error("Gemini API error: %s", e)
        raise
