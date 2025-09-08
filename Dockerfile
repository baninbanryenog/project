
# backend/Dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y build-essential default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# cryptography, PyMySQL/SQLAlchemy 등은 requirements.txt에 넣어줘
# 예) flask==3.*, gunicorn, sqlalchemy, pymysql, cryptography, redis, boto3, python-dotenv 등

COPY . .

# gunicorn으로 서비스 (EKS Service는 8000 포트 노출 가정)
EXPOSE 8000
CMD ["gunicorn", "-w", "3", "-k", "gthread", "-b", "0.0.0.0:8000", "app:app"]
