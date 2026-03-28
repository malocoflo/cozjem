from pydantic import BaseModel
from typing import Optional


class Ingredient(BaseModel):
    name: str
    category: str
    confidence: str


class FridgeAnalysisResponse(BaseModel):
    ingredients: list[Ingredient]


class IngredientsRequest(BaseModel):
    ingredients: list[str]


class RecipeSuggestion(BaseModel):
    title: str
    description: str
    duration_minutes: int
    tags: list[str] = []
    matched_ingredients: int
    total_ingredients: int
    required_ingredients: list[str] = []
    all_ingredients_available: bool = False


class RecipeSuggestionsResponse(BaseModel):
    recipes: list[RecipeSuggestion]


class ErrorResponse(BaseModel):
    detail: str
