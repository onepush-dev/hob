#!/bin/sh
# Railway mounts volumes root-owned: hand /data to the image's `node` user,
# then drop privileges and start Hob exactly as upstream does.
set -eu
HOME_DIR="${HOB_HOME:-/data}"
mkdir -p "$HOME_DIR"
chown -R node:node "$HOME_DIR" 2>/dev/null || true
if [ -z "${HOB_PASSWORD:-}" ] && [ ! -f "$HOME_DIR/system/config.json" ]; then
  echo "HOB_PASSWORD is empty and no password is stored yet; refusing to start." >&2
  exit 1
fi
cd /app
exec setpriv --reuid=node --regid=node --init-groups -- node bin/hob.mjs "$@"
