const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // Upsert Challenge
  const challenge = await prisma.challenge.upsert({
    where: { id: '123e4567-e89b-12d3-a456-426614174000' },
    update: {}, // No update needed if exists
    create: {
      id: '123e4567-e89b-12d3-a456-426614174000',
      name: 'Sample Challenge',
      description: 'A test challenge',
      status: 'NEW',
      createdBy: 'user1',
      updatedBy: 'user1',
    },
  });
  console.log('Upserted Challenge:', challenge);

  // Upsert ResourceRole
  const resourceRole = await prisma.resourceRole.upsert({
    where: { id: '550e8400-e29b-41d4-a716-446655440000' },
    update: {},
    create: {
      id: '550e8400-e29b-41d4-a716-446655440000',
      name: 'Developer',
      fullReadAccess: true,
      fullWriteAccess: true,
      isActive: true,
      selfObtainable: false,
      legacyId: 1001,           // Optional example value
      nameLower: 'developer',   // Required, lowercase name
      createdBy: 'user1',
      updatedBy: 'user1',
    },
  });
  
  
  console.log('Upserted ResourceRole:', resourceRole);

  // Create Resource (no unique constraint, so create is fine)
  const resource = await prisma.resource.create({
    data: {
      challengeId: '123e4567-e89b-12d3-a456-426614174000',
      memberId: 'member1',
      memberHandle: 'handle1',
      roleId: '550e8400-e29b-41d4-a716-446655440000',
      createdBy: 'user1',
      updatedBy: 'user1',
    },
  });
  console.log('Created Resource:', resource);
}

main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());