# Use NVIDIA CUDA base image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user

# Clone the repository
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /home/user/stable-diffusion-webui

# Create and activate virtual environment
RUN python3 -m venv venv
ENV PATH="/home/user/stable-diffusion-webui/venv/bin:$PATH"

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118 && \
    pip install -r requirements.txt

# Expose port
EXPOSE 7860

# Set entrypoint
ENTRYPOINT ["python3", "launch.py", "--listen", "--enable-insecure-extension-access", "--xformers"]
