from fastapi import APIRouter, UploadFile, File, HTTPException, Depends
from ..models.schemas import FridgeAnalysisResponse, IngredientsRequest, RecipeSuggestionsResponse
from ..services.gemini_service import analyze_fridge_image, suggest_recipes, GeminiServiceError
from ..config import Settings, get_settings
import logging

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["fridge"])

ALLOWED_MIME_TYPES = {"image/jpeg", "image/png", "image/webp"}


@router.post(
    "/analyze-fridge",
    response_model=FridgeAnalysisResponse,
    summary="Analyze fridge contents from an image",
)
async def analyze_fridge(
    file: UploadFile = File(...),
    settings: Settings = Depends(get_settings),
):
    # Validate content type
    if file.content_type not in ALLOWED_MIME_TYPES:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid file type '{file.content_type}'. Allowed: JPEG, PNG, WebP.",
        )

    # Read and validate size
    max_bytes = settings.max_file_size_mb * 1024 * 1024
    image_data = await file.read()
    if len(image_data) > max_bytes:
        raise HTTPException(
            status_code=413,
            detail=f"File too large. Maximum size is {settings.max_file_size_mb} MB.",
        )

    try:
        result = await analyze_fridge_image(image_data, file.content_type)
        return result
    except ValueError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except GeminiServiceError as e:
        raise HTTPException(status_code=e.status_code, detail=e.message)
    except Exception as e:
        logger.error("Unexpected error analyzing fridge: %s", e)
        raise HTTPException(
            status_code=503,
            detail="AI service temporarily unavailable. Please try again later.",
        )


@router.post(
    "/suggest-recipes",
    response_model=RecipeSuggestionsResponse,
    summary="Suggest recipes based on detected ingredients",
)
async def suggest_recipes_endpoint(
    request: IngredientsRequest,
):
    if not request.ingredients:
        raise HTTPException(
            status_code=400,
            detail="At least one ingredient must be provided.",
        )

    try:
        return await suggest_recipes(request.ingredients)
    except ValueError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except GeminiServiceError as e:
        raise HTTPException(status_code=e.status_code, detail=e.message)
    except Exception as e:
        logger.error("Unexpected error suggesting recipes: %s", e)
        raise HTTPException(
            status_code=503,
            detail="AI service temporarily unavailable. Please try again later.",
        )
