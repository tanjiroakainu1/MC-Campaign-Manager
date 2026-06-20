import { defineComputeConfig } from '@prisma/compute-sdk/config';

export default defineComputeConfig({
  app: {
    name: 'marketing-campaign-management',
    framework: 'bun',
    entry: 'server/index.ts',
    httpPort: 3001,
    build: {
      command: 'npm run build',
      outputDirectory: 'dist',
    },
    env: {
      vars: {
        NODE_ENV: 'production',
        HOST: '0.0.0.0',
      },
    },
  },
});
