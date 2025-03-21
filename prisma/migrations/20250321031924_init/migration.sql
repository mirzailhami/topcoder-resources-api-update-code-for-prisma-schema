-- CreateTable
CREATE TABLE "Resource" (
    "id" TEXT NOT NULL,
    "challengeId" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "memberHandle" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT,
    "updated" TIMESTAMP(3) NOT NULL,
    "updatedBy" TEXT,

    CONSTRAINT "Resource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResourceRole" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "fullReadAccess" BOOLEAN NOT NULL,
    "fullWriteAccess" BOOLEAN NOT NULL,
    "isActive" BOOLEAN NOT NULL,
    "selfObtainable" BOOLEAN NOT NULL,
    "legacyId" INTEGER,
    "nameLower" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL,
    "updatedBy" TEXT,

    CONSTRAINT "ResourceRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResourceRolePhaseDependency" (
    "id" TEXT NOT NULL,
    "phaseId" TEXT NOT NULL,
    "resourceRoleId" TEXT NOT NULL,
    "phaseState" BOOLEAN NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL,
    "updatedBy" TEXT,

    CONSTRAINT "ResourceRolePhaseDependency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MemberStats" (
    "userId" INTEGER NOT NULL,
    "handle" TEXT NOT NULL,
    "handleLower" TEXT NOT NULL,
    "maxRating" JSONB,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedBy" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MemberStats_pkey" PRIMARY KEY ("userId")
);

-- CreateTable
CREATE TABLE "MemberProfile" (
    "userId" INTEGER NOT NULL,
    "handle" TEXT NOT NULL,
    "handleLower" TEXT NOT NULL,
    "email" TEXT,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedBy" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MemberProfile_pkey" PRIMARY KEY ("userId")
);

-- CreateTable
CREATE TABLE "Challenge" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'NEW',
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "projectId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "updatedBy" TEXT NOT NULL,

    CONSTRAINT "Challenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Phase" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isOpen" BOOLEAN NOT NULL DEFAULT false,
    "duration" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "updatedBy" TEXT NOT NULL,

    CONSTRAINT "Phase_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Resource_challengeId_idx" ON "Resource"("challengeId");

-- CreateIndex
CREATE INDEX "Resource_memberId_idx" ON "Resource"("memberId");

-- CreateIndex
CREATE INDEX "Resource_challengeId_memberId_idx" ON "Resource"("challengeId", "memberId");

-- CreateIndex
CREATE INDEX "Resource_memberId_roleId_idx" ON "Resource"("memberId", "roleId");

-- CreateIndex
CREATE INDEX "ResourceRole_nameLower_idx" ON "ResourceRole"("nameLower");

-- CreateIndex
CREATE INDEX "ResourceRolePhaseDependency_phaseId_idx" ON "ResourceRolePhaseDependency"("phaseId");

-- CreateIndex
CREATE INDEX "ResourceRolePhaseDependency_resourceRoleId_idx" ON "ResourceRolePhaseDependency"("resourceRoleId");

-- CreateIndex
CREATE INDEX "MemberStats_handleLower_idx" ON "MemberStats"("handleLower");

-- CreateIndex
CREATE INDEX "MemberProfile_handleLower_idx" ON "MemberProfile"("handleLower");

-- CreateIndex
CREATE INDEX "Challenge_projectId_idx" ON "Challenge"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Phase_name_key" ON "Phase"("name");

-- AddForeignKey
ALTER TABLE "Resource" ADD CONSTRAINT "Resource_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "ResourceRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Resource" ADD CONSTRAINT "Resource_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceRolePhaseDependency" ADD CONSTRAINT "ResourceRolePhaseDependency_resourceRoleId_fkey" FOREIGN KEY ("resourceRoleId") REFERENCES "ResourceRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceRolePhaseDependency" ADD CONSTRAINT "ResourceRolePhaseDependency_phaseId_fkey" FOREIGN KEY ("phaseId") REFERENCES "Phase"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
