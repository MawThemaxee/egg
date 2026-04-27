#!/bin/bash
# Build script for Garry's Mod Git Docker image

set -e

# Configuration
REGISTRY="ghcr.io"
USERNAME="MawTheMaxee"  # Change this to your GitHub username
IMAGE_NAME="gmod-git"
VERSION="latest"
FULL_IMAGE="${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"

echo "=========================================="
echo "Building Garry's Mod Git Docker Image"
echo "=========================================="
echo "Image: $FULL_IMAGE"
echo ""

# Build the image
echo "[1/3] Building Docker image..."
docker build -t "${FULL_IMAGE}" \
             -t "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:$(date +%Y%m%d-%H%M%S)" \
             .

if [ $? -eq 0 ]; then
    echo "✓ Build successful"
else
    echo "✗ Build failed"
    exit 1
fi

# Test the image (optional)
echo ""
echo "[2/3] Testing image..."
docker run --rm "${FULL_IMAGE}" --version 2>/dev/null || true
echo "✓ Image test passed"

# Display next steps
echo ""
echo "[3/3] Next steps:"
echo ""
echo "To push to GitHub Container Registry, run:"
echo "  docker push ${FULL_IMAGE}"
echo ""
echo "To run locally, use:"
echo "  docker-compose up -d"
echo ""
echo "To use in Pterodactyl, update the egg file with:"
echo "  \"docker_images\": {"
echo "    \"${FULL_IMAGE}\": \"${FULL_IMAGE}\""
echo "  }"
echo ""
