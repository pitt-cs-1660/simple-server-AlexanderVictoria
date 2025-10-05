
# Build stage
FROM python:3.12-slim AS builder

# install uv package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# copy only dependency files first (better caching)
COPY pyproject.toml ./
COPY tests ./tests

ENV VIRTUAL_ENV=/app/.venv
ENV PATH="/app/.venv/bin:${PATH}"
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONPATH=/app:$PYTHONPATH

# install dependencies with uv
RUN uv sync --no-install-project --no-editable

# final stage - runtime environment
FROM python:3.12-slim

WORKDIR /app

# Copy venv from builder
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:${PATH}"

# Copy tests directory into final stage
COPY --from=builder /app/tests ./tests

COPY cc_simple_server ./cc_simple_server


# document the port
EXPOSE 8000

# bind to all interfaces in container
CMD ["uvicorn", "cc_simple_server.server:app", "--host", "0.0.0.0", "--port", "8000"]
