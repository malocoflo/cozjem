from pydantic_settings import BaseSettings
from pydantic import field_validator
from functools import lru_cache
import logging

logger = logging.getLogger(__name__)


class Settings(BaseSettings):
    gemini_api_key: str = ""
    max_file_size_mb: int = 10
    allowed_origins: list[str] = ["*"]

    @field_validator("gemini_api_key")
    @classmethod
    def warn_if_empty(cls, v: str) -> str:
        if not v:
            logger.warning(
                "GEMINI_API_KEY is not set. The /api/analyze-fridge endpoint will not work."
            )
        return v

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


@lru_cache()
def get_settings() -> Settings:
    return Settings()
