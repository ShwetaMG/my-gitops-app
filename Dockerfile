# --- Stage 1: Build & Dependencies ---
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies if needed, and compile python wheels
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt


# --- Stage 2: Final Lightweight Runtime ---
FROM python:3.11-alpine AS runner

WORKDIR /app

# Copy only the installed dependencies from the builder stage
COPY --from=builder /root/.local /root/.local
# Copy the application source code
COPY app.py .

# Ensure the locally installed modules are in the python path
ENV PATH=/root/.local/bin:$PATH
ENV APP_ENV=Production

EXPOSE 5000

CMD ["python", "app.py"]