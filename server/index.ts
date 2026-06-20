import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import apiRoutes from './routes';
import { seedDatabase } from './db';

const app = express();
const PORT = Number(process.env.PORT) || 3001;
const HOST = process.env.HOST || '0.0.0.0';

app.use(cors());
app.use(express.json());
app.use('/api', apiRoutes);

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
