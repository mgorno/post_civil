# Dockerfile
FROM python:3.12.6-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencias del sistema (sqlite, zlib, etc. por las dudas)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates build-essential curl sqlite3 libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Fly expone $PORT; usamos 8080 por defecto
ENV PORT=8080
CMD ["gunicorn","-w","2","-b","0.0.0.0:8080","app:app"]
