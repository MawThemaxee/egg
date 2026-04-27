#!/bin/bash
# Push script to GitHub Container Registry

set -e

# Configuration
REGISTRY="ghcr.io"
USERNAME="MawTheMaxee"  # Change this to your GitHub username
IMAGE_NAME="gmod-git"
VERSION="latest"
FULL_IMAGE="${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"

echo "=========================================="
echo "Pushing Garry's Mod Git Docker Image to GitHub"
echo "=========================================="
echo ""

# Check if Docker is logged in to GitHub
echo "[1/2] Checking authentication..."
if ! docker info | grep -q "Username"; then
    echo "⚠ Not authenticated to Docker/GitHub"
    echo "Run: docker login ghcr.io"
    echo "Username: YOUR_GITHUB_USERNAME"
    echo "Password: YOUR_GITHUB_TOKEN (with read:packages, write:packages scopes)"
    echo ""
    exit 1
fi
echo "✓ Authenticated"

# Push the image
echo ""
echo "[2/2] Pushing image to GitHub Container Registry..."
echo "Image: $FULL_IMAGE"
echo ""

if docker push "${FULL_IMAGE}"; then
    echo ""
    echo "✓ Push successful!"
    echo ""
    echo "Image is now available at:"
    echo "  ${FULL_IMAGE}"
    echo ""
    echo "To use in Pterodactyl egg, update docker_images to:"
    echo "  \"${FULL_IMAGE}\": \"${FULL_IMAGE}\""
else
    echo "✗ Push failed"
    exit 1
fi
