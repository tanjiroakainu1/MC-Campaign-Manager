import path from 'path';
import { fileURLToPath } from 'url';
import express from 'express';
import app from './app';
import { seedDatabase } from './db';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PORT = Number(process.env.PORT) || 3001;
const HOST = process.env.HOST || '0.0.0.0';
const isProduction = process.env.NODE_ENV === 'production';

if (isProduction && !process.env.VERCEL) {
  const distPath = path.join(__dirname, '../dist');
  app.use(express.static(distPath));
  app.get('*', (req, res, next) => {
    if (req.path.startsWith('/api')) return next();
    res.sendFile(path.join(distPath, 'index.html'));
  });
}

async function start() {
  try {
    await seedDatabase();
    app.listen(PORT, HOST, () => {
      console.log(`API server running on http://${HOST === '0.0.0.0' ? 'localhost' : HOST}:${PORT}`);
      console.log(`Prisma sync endpoint: http://localhost:${PORT}/api/sync`);
      console.log(`Mobile clients: use your machine IP with port ${PORT}`);
    });
  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
}

start();
