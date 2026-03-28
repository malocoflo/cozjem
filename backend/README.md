# CoZjem Backend

Python FastAPI backend with Google Gemini 1.5 Flash for AI-powered fridge image analysis.

## Requirements

- Python 3.11+
- Google Gemini API key ([Get one here](https://aistudio.google.com/))

## Setup

```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env and set your GEMINI_API_KEY
```

## Running

```bash
# From the backend/ directory
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at http://localhost:8000.
Interactive docs: http://localhost:8000/docs

## API Endpoints

### `POST /api/analyze-fridge`

Analyze a fridge image and return identified ingredients.

**Request:** `multipart/form-data` with `file` field (JPEG/PNG/WebP image)

**Response:**
```json
{
  "ingredients": [
    {"name": "Jajka", "category": "Nabiał", "confidence": "high"},
    {"name": "Mleko", "category": "Nabiał", "confidence": "high"},
    {"name": "Pomidory", "category": "Warzywa", "confidence": "medium"}
  ]
}
```

**Errors:**
- `400` — Invalid file type
- `413` — File too large (default max: 10 MB)
- `500` — Failed to parse AI response
- `503` — AI service unavailable

### `GET /health`

Health check endpoint.
