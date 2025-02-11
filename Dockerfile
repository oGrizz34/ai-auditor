# Use the Debian Bullseye-based Python 3.12 image.
FROM python:3.11-bullseye

# Prevent Python from writing .pyc files and enable unbuffered output.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Force setuptools to use the standard library's distutils.
ENV SETUPTOOLS_USE_DISTUTILS=stdlib

# Set the working directory.
WORKDIR /app

# Install system dependencies required for building Python packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    cmake \
    libgomp1 \
    python3-dev \
    python3-distutils \
    libffi-dev \
    libssl-dev \
    libatlas-base-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container.
COPY requirements.txt /app/

# Upgrade pip, and install setuptools (pinned to 68.2.0) and wheel.
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools==68.2.0 wheel

# Pre-install Cython (helps with building C extensions).
RUN pip install cython

# Install Python dependencies from requirements.txt without using cache.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files.
COPY . /app/

# Expose port 8080 (required by Cloud Run).
EXPOSE 8080

# Start the FastAPI app using Uvicorn on port 8080.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]









