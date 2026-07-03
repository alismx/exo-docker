FROM nvidia/cuda:12.9.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies from README (Ubuntu/Debian instructions)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install uv (Python dependency manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Rust (nightly toolchain)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path && \
    /root/.cargo/bin/rustup toolchain install nightly

ENV PATH="/root/.local/bin:/root/.cargo/bin:$PATH"

WORKDIR /app

# Clone the repo
RUN git clone https://github.com/exo-explore/exo.git .

# Build dashboard
WORKDIR /app/dashboard
RUN npm install && npm run build

WORKDIR /app

# Run exo
ENTRYPOINT ["uv", "run", "exo"]
