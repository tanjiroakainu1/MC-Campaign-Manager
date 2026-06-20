# Marketing Campaign Management System

Web (`src/`) + Mobile (`mobiledevelopment/`) sharing one **Prisma Postgres** database via Express API.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐
│  Web (src/)     │     │ Mobile (Flutter)│
│  Vite :5173     │     │ mobiledevelopment│
└────────┬────────┘     └────────┬────────┘
         │  /api proxy           │  HTTP API_BASE
         └──────────┬────────────┘
                    ▼
         ┌──────────────────────┐
         │  Express API :3001   │
         │  server/ + Prisma    │
         └──────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │  Prisma Postgres     │
         │  (public / mcm_*)  │
         └──────────────────────┘
```

Both clients sync via `GET /api/sync` every 20 seconds and on focus/resume. Changes on web appear on mobile and vice versa.

## Authentication

| Role | Name | Email | Password |
|------|------|-------|----------|
| Super Admin | Alex Rivera | alex@company.com | admin123 |
| Marketing Manager | Sarah Chen | sarah@company.com | manager123 |
| Content Creator | Mike Johnson | mike@company.com | creator123 |
| Marketing Analyst | Emma Wilson | emma@company.com | analyst123 |

## Setup

### 1. Environment

Credentials for **Brilliant Copper Skunk** (`db_cmqm1alvu0k4k1mf5d4aca2sg`) are in `.env.example`. Copy if you don't have `.env` yet:

```bash
cp .env.example .env
```

- `DATABASE_URL` — pooled (`pooled.db.prisma.io`) for app runtime
- `DATABASE_URL_DIRECT` — direct (`db.prisma.io`) for migrations

### 2. Install & migrate

```bash
npm install
npx prisma db push    # or npm run db:migrate
```

### 3. Run web + API

```bash
npm run dev
```

Opens Vite on `http://localhost:5173` and API on `http://localhost:3001`.

### 4. Run mobile (same database)

```bash
cd mobiledevelopment
flutter pub get
flutter run
```

**Android device (same Wi‑Fi):**
```bash
flutter run --dart-define=API_BASE=http://YOUR_LOCAL_IP:3001/api
```

**Release APK (Android + Prisma sync):**
```bash
npm run apk:publish
# Copies APK to public/downloads/ — downloadable from home page at /downloads/campaign-manager.apk
# Or: cd mobiledevelopment && ./scripts/build_apk.sh https://mc-campaign-manager.vercel.app
```
Phone must reach the Express API (same Wi‑Fi for LAN, or deploy API publicly).

## Data layer

| Layer | Web | Mobile |
|-------|-----|--------|
| API client | `src/lib/api.ts` | `lib/src/lib/api.dart` |
| Cache | `src/data/dataStore.ts` | `lib/src/data/dataStore.dart` |
| Auth | `src/context/AuthContext.tsx` | `lib/src/context/AuthContext.dart` |
| Bootstrap | `src/context/BootstrapContext.tsx` | `lib/src/context/BootstrapContext.dart` |

All mutations go through the API → Prisma. Session only is stored locally (web: `localStorage`, mobile: `SharedPreferences`). System settings, campaign metrics, and notifications are also persisted in Prisma (`mcm_settings`, `mcm_campaign_metrics`).

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | API + Vite together |
| `npm run server` | Express API only |
| `npm run client` | Vite only |
| `npm run db:studio` | Prisma Studio |
| `npm run build` | Production web build (Vite → `dist/`) |
| `npm run vercel-build` | Vercel: generate + migrate + Vite build |
| `npm start` | Production API + static web (`NODE_ENV=production`) |
| `npm run db:deploy` | Apply migrations (Prisma Platform / production) |

## Prisma Platform deploy

The app is configured in `prisma.compute.ts` (Bun + Express entry `server/index.ts`, Vite build → `dist/`).

**Required env vars in Prisma Console → Environment variables:**

| Variable | Value |
|----------|-------|
| `DATABASE_URL` | Pooled connection (`pooled.db.prisma.io`) |
| `DATABASE_URL_DIRECT` | Direct connection (`db.prisma.io`) |
| `PORT` | `3001` (or platform-assigned port) |
| `HOST` | `0.0.0.0` |
| `NODE_ENV` | `production` |

Build deps (`vite`, `tailwindcss`, etc.) are in `dependencies` so production installs can run `npm run build`.

## Vercel deploy

`vercel.json` serves the Vite app from `dist/` and routes `/api/*` to the Express serverless function (`api/index.ts`).

1. Import repo: https://github.com/tanjiroakainu1/MC-Campaign-Manager
2. Framework preset: **Other** (uses `vercel.json`)
3. Add environment variables:

| Variable | Value |
|----------|-------|
| `DATABASE_URL` | Pooled Prisma Postgres URL |
| `DATABASE_URL_DIRECT` | Direct URL (for `prisma migrate deploy` in build) |
| `NODE_ENV` | `production` |

4. Deploy — build runs `npm run vercel-build` (generate → migrate → vite build).

After deploy, test `https://your-app.vercel.app/api/health` and open the site root for the web UI. Mobile APK: `./scripts/build_apk.sh https://your-app.vercel.app`

## Project structure

```
src/                    # Web React app
mobiledevelopment/      # Flutter mobile app (mirrors src/)
server/                 # Express + Prisma API
prisma/                 # Schema & migrations
```
