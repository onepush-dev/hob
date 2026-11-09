#!/bin/sh
# Railway mounts volumes root-owned: hand /data to the image's `node` user,
# make Hob listen on $PORT (HOB_PORT; upstream image pins 30148), then
# drop privileges and start Hob exactly as upstream does.
set -eu
HOME_DIR="${HOB_HOME:-/data}"
PORT="${PORT:-8080}"
mkdir -p "$HOME_DIR/system"
if [ -z "${HOB_PASSWORD:-}" ] && [ ! -f "$HOME_DIR/system/config.json" ]; then
  echo "HOB_PASSWORD is empty and no password is stored yet; refusing to start." >&2
  exit 1
fi
export HOB_PORT="$PORT"
chown -R node:node "$HOME_DIR" 2>/dev/null || true
cd /app
exec setpriv --reuid=node --regid=node --init-groups -- node bin/hob.mjs "$@"
