#!/bin/sh
# Railway mounts volumes root-owned: hand /data to the image's `node` user,
# pin Hob's listen port to $PORT (Hob reads it from system/config.json), then
# drop privileges and start Hob exactly as upstream does.
set -eu
HOME_DIR="${HOB_HOME:-/data}"
PORT="${PORT:-8080}"
mkdir -p "$HOME_DIR/system"
if [ -z "${HOB_PASSWORD:-}" ] && [ ! -f "$HOME_DIR/system/config.json" ]; then
  echo "HOB_PASSWORD is empty and no password is stored yet; refusing to start." >&2
  exit 1
fi
node -e '
const fs=require("fs"),f=process.argv[1],p=Number(process.argv[2]);
let c={};try{c=JSON.parse(fs.readFileSync(f,"utf8"))}catch{}
if(c.port!==p){c.port=p;fs.writeFileSync(f,JSON.stringify(c,null,2)+"\n",{mode:0o600})}
' "$HOME_DIR/system/config.json" "$PORT"
chown -R node:node "$HOME_DIR" 2>/dev/null || true
cd /app
exec setpriv --reuid=node --regid=node --init-groups -- node bin/hob.mjs "$@"
