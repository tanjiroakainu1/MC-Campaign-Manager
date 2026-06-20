/** Shared API configuration — web + mobile both hit the same Prisma-backed Express server */

export const API_PORT = Number(import.meta.env.VITE_API_PORT) || 3001;

/** Override in production: VITE_API_URL=http://your-host:3001/api */
export const API_BASE =
  import.meta.env.VITE_API_URL ?? `/api`;

/** Background sync interval (ms) — keeps web & mobile in sync via Prisma */
export const SYNC_INTERVAL_MS = 20_000;
