import 'dotenv/config';
import { prisma } from '../server/prisma';
import { seedDatabase } from '../server/db';

async function main() {
  const seeded = await seedDatabase();
  console.log(seeded ? 'Database seeded successfully' : 'Database already has data — skipped seed');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
