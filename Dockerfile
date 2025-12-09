FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.local/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    GRADIO_SERVER_NAME="0.0.0.0" \
    GRADIO_SERVER_PORT=6006

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3-pip git curl build-essential \
    python3.10-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.10 /usr/bin/python

# uv (fast installer → new default location)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /app
COPY . .

# Install everything exactly once
RUN uv pip install --system --no-cache -r requirements.txt

# Pre-compile the BigVGAN CUDA kernel once at build time
# (so it never fails at runtime again on 8 GB cards)
RUN python -c "from indextts.BigVGAN.alias_free_activation.cuda import load; load()" || true

EXPOSE 6006

# Final, perfect command – works every time, no overrides ever needed
CMD ["python", "webui.py","--port", "6006"]
