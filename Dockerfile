
# Build stage
FROM python:3.12-slim AS builder

# install uv package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# copy only dependency files first (better caching)
COPY pyproject.toml ./

ENV VIRTUAL_ENV=/app/.venv
ENV PATH="/app/.venv/bin:${PATH}"
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# install dependencies with uv
RUN uv sync --no-install-project --no-editable

# final stage - runtime environment
FROM python:3.12-slim

WORKDIR /app

# Copy venv from builder
COPY --from=builder /app/.venv /app/.venv

# Copy tests directory into final stage
COPY --from=builder /app/tests ./tests

# document the port
EXPOSE 8000

# bind to all interfaces in container
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
