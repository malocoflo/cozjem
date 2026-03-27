from pydantic import BaseModel
from typing import Optional


class Ingredient(BaseModel):
    name: str
    category: str
    confidence: str


class FridgeAnalysisResponse(BaseModel):
    ingredients: list[Ingredient]


class ErrorResponse(BaseModel):
    detail: str
