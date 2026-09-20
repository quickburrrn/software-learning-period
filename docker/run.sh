#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
IMAGE="${IMAGE:-software-learning-period:latest}"
CONTAINER_NAME="${CONTAINER_NAME:-software-learning-period}"
# Keep files created in the source mount owned by the host user, even with sudo.
HOST_UID="${SUDO_UID:-$(id -u)}"
HOST_GID="${SUDO_GID:-$(id -g)}"
docker run -it --rm --name "$CONTAINER_NAME" \
    --user "$HOST_UID:$HOST_GID" \
    -p 127.0.0.1:8765:8765 \
    --mount "type=bind,source=$REPO_DIR,target=/ros2_ws/src/software-learning-period" \
    -w /ros2_ws "$IMAGE" bash
