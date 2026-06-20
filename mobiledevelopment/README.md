# Campaign Manager — Android (Online)

Online app that syncs with **Prisma Postgres** via the Express API.

## Requirements

- Android device with internet (Wi‑Fi or mobile data)
- Express API running and reachable (`npm run server` from project root, or deployed online)
- Prisma `DATABASE_URL` configured in project root `.env`

## Quick test (same Wi‑Fi as your PC)

1. Start API on your machine:
   ```bash
   cd .. && npm run server
   ```
2. Find your PC local IP (e.g. `192.168.1.10`)
3. Run on device/emulator:
   ```bash
   flutter run --dart-define=API_BASE=http://192.168.1.10:3001/api
   ```

## Build release APK (online Prisma sync)

**APK output:** `build/app/outputs/flutter-apk/app-release.apk`

1. Start API (binds `0.0.0.0:3001` — reachable on LAN):
   ```bash
   cd .. && npm run server
   ```
2. Get your PC IP: `ipconfig getifaddr en0` (e.g. `192.168.0.101`)
3. Build APK with API URL baked in:
   ```bash
   ./scripts/build_apk.sh http://192.168.0.101:3001
   ```
4. Install on Android (same Wi‑Fi) — app auto-syncs from Prisma on launch

For a **public** server, deploy Express API and use:
```bash
./scripts/build_apk.sh https://your-deployed-api.com
```

**Current build:** API → `http://192.168.0.101:3001/api` → Prisma Postgres (Brilliant Copper Skunk)

## First launch

| Screen | When |
|--------|------|
| **Connect to Prisma** | Release APK with no API URL configured |
| **You're offline** | No internet connection |
| **Syncing…** | Loading data from `/api/sync` |
| **App** | Connected — green cloud icon in header |

## In-app controls

- **Green cloud** — online, synced with Prisma
- **Sync button** — manual refresh from database
- **Server settings** — change API URL (saved on device)

## Android permissions

- `INTERNET` — required for online sync
- `ACCESS_NETWORK_STATE` — offline detection

## Architecture

```
Android APK  →  HTTP /api/sync  →  Express :3001  →  Prisma Postgres
                     ↑
              Web (src/) same API
```

Changes on web appear on Android within ~20 seconds (auto-sync).
