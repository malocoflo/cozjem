from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import fridge
from .config import get_settings
import logging

logging.basicConfig(level=logging.INFO)

settings = get_settings()

app = FastAPI(
    title="CoZjem API",
    description="AI-powered fridge scanner and recipe assistant",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(fridge.router)


@app.get("/health", tags=["health"])
async def health_check():
    return {"status": "ok"}
