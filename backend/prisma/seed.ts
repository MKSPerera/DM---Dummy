import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const hashedPassword = await bcrypt.hash('admin123', 10);

  const admin = await prisma.admin.upsert({
    where: { email: 'admin@example.com' }, 
    update: {},
    create: {
      email: 'admin@example.com',
      username: 'admin',
      password: hashedPassword,
    },
  });

  console.log('Admin user created:', admin);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });