#!/usr/bin/env bash
set -euo pipefail

TARBALL="docker-images/firefox.tar"
CONTAINER="firefox"
PORT=5800
VOLDIR="/docker/appdata/firefox"

# Load image if missing
if ! docker image inspect jlesage/firefox:latest >/dev/null 2>&1; then
  echo "→ Loading image from $TARBALL…"
  docker load -i "$TARBALL"
fi

# Remove any old container
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  docker rm -f "$CONTAINER"
fi

# Start fresh
docker run -d \
  --name "$CONTAINER" \
  -p "${PORT}:${PORT}" \
  -v "${VOLDIR}:/config:rw" \
  jlesage/firefox:latest

echo "🔥 Firefox is up (port $PORT)"
