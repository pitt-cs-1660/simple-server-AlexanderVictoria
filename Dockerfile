# Copy venv from builder
COPY --from=builder /app/.venv /app/.venv

# Copy tests directory into final stage
COPY --from=builder /app/tests ./tests

# Build stage
FROM python:3.12 as builder
# Install uv and dependencies...

# Final stage  
FROM python:3.12-slim
# Copy venv from builder stage...