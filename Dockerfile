# Build stage
FROM python:3.12 as builder
# Install uv and dependencies...

# Final stage  
FROM python:3.12-slim
# Copy venv from builder stage...