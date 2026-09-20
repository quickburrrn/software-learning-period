#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
IMAGE="${IMAGE:-software-learning-period:latest}"
BASE_IMAGE="${BASE_IMAGE:-ros:humble}"
PLATFORM="${PLATFORM:-linux/amd64}"
docker buildx build --platform "$PLATFORM" \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    --build-arg TARGET_PLATFORM="$PLATFORM" \
    --tag "$IMAGE" --file "$SCRIPT_DIR/Dockerfile" --load "$REPO_DIR"
