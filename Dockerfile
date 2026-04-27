FROM ghcr.io/ptero-eggs/games:source

# Install git and other useful tools
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    nano \
    vim \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Configure git (optional - sets default user for automated commits if needed)
RUN git config --global user.email "noreply@pterodactyl.local" && \
    git config --global user.name "Pterodactyl Server"

# Set working directory
WORKDIR /home/container

# Expose default game server port and query port
EXPOSE 27015/udp 27015/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ps aux | grep srcds_linux | grep -v grep || exit 1

# Default entrypoint (can be overridden by Pterodactyl)
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "cd /home/container && ./srcds_run -game garrysmod -console"]
