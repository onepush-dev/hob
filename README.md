# Hob on Railway

Hob — a self-hosted personal assistant that runs background jobs, routines and delegated coding-agent tasks from one web chat. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/zJhVDR)

This repository packages the official [Hob](https://github.com/FFatTiger/hob) image (`ghcr.io/ffattiger/hob:1.5.0`, MIT) for Railway. It is an independent community packaging, not affiliated with or endorsed by the Hob project.

## What you get

- One service from `ghcr.io/onepush-dev/hob:1.5.0-r3`: the upstream image unmodified, plus a start script that hands Railway's root-owned `/data` volume to the `node` user, makes Hob listen on `[::]:$PORT` (8080) and drops privileges.
- **Password from the start**: the template generates `HOB_PASSWORD`; Hob hashes it into `/data/system/config.json` on first start. There is no open setup screen.
- **Persistent data** on a Railway volume at `/data`: chats, jobs, routines, engine sessions and settings.

## Use it

1. Deploy, open the public URL and sign in with `HOB_PASSWORD` from the service's Variables tab.
2. Add your model provider (Anthropic, OpenAI or any compatible endpoint) in Hob's settings. Hob boots and serves the UI without a key; jobs need one.
3. Change the password in Hob's settings if you like. After the first start the stored hash wins, so editing `HOB_PASSWORD` later has no effect.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `HOB_PASSWORD` | generated (24 chars) | Web sign-in password, hashed into the volume on first start |
| `TZ` | `UTC` (baked) | Time zone for routines and schedules |

The optional `hob-desktop` (remote browser desktop) profile from upstream compose is not included.
