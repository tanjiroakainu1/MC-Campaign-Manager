import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import apiRoutes from './routes';
import { seedDatabase } from './db';

const app = express();

app.use(cors());
app.use(express.json({ limit: '4mb' }));

let seedPromise: Promise<boolean> | null = null;
app.use((_req, _res, next) => {
  if (!seedPromise) seedPromise = seedDatabase();
  seedPromise.then(() => next()).catch(next);
});

app.use('/api', apiRoutes);

export default app;
