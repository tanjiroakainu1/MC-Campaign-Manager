import 'dotenv/config';
import { defineConfig } from 'prisma/config';

// Placeholder for `prisma generate` in CI/Compute builds when DB env vars are not injected yet.
const buildDatasourceUrl =
  process.env.DATABASE_URL ??
  'postgresql://build:build@localhost:5432/build?schema=public';
const buildDirectUrl =
  process.env.DATABASE_URL_DIRECT ?? buildDatasourceUrl;

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'tsx prisma/seed.ts',
  },
  datasource: {
    url: buildDatasourceUrl,
    directUrl: buildDirectUrl,
  },
});
