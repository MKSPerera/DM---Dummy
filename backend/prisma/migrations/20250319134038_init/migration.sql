-- CreateEnum
CREATE TYPE "AvailabilityStatus" AS ENUM ('BUSY', 'JOB');

-- CreateEnum
CREATE TYPE "JobState" AS ENUM ('PENDING', 'ACCEPTED', 'ONGOING', 'COMPLETED');

-- CreateEnum
CREATE TYPE "PostType" AS ENUM ('PUBLIC', 'PRIVATE');

-- CreateTable
CREATE TABLE "Driver" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "contactNumber" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "vehicleType" TEXT NOT NULL,
    "vehicleCapacity" INTEGER NOT NULL,
    "vehicleLicense" TEXT NOT NULL,

    CONSTRAINT "Driver_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DriverRanking" (
    "id" SERIAL NOT NULL,
    "driverId" INTEGER NOT NULL,
    "workRate" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "feedbackRate" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "cancellationRate" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "averageRate" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DriverRanking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Admin" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminDriverRelation" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER NOT NULL,
    "driverId" INTEGER NOT NULL,
    "isBlocked" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminDriverRelation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Job" (
    "jobId" SERIAL NOT NULL,
    "clientName" TEXT NOT NULL,
    "nationality" TEXT NOT NULL,
    "numberOfPassengers" INTEGER NOT NULL,
    "pickupLocation" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "pickupTime" TIMESTAMP(3) NOT NULL,
    "distance" DOUBLE PRECISION NOT NULL,
    "paymentAmount" DOUBLE PRECISION NOT NULL,
    "additionalDetails" TEXT,
    "postType" "PostType" NOT NULL,
    "currentState" "JobState" NOT NULL DEFAULT 'PENDING',
    "jobCreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assignedDriverId" INTEGER,

    CONSTRAINT "Job_pkey" PRIMARY KEY ("jobId")
);

-- CreateTable
CREATE TABLE "Availability" (
    "id" SERIAL NOT NULL,
    "driverId" INTEGER NOT NULL,
    "jobId" INTEGER,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "status" "AvailabilityStatus" NOT NULL,

    CONSTRAINT "Availability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JobDriverAccess" (
    "id" SERIAL NOT NULL,
    "jobId" INTEGER NOT NULL,
    "driverId" INTEGER NOT NULL,

    CONSTRAINT "JobDriverAccess_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Driver_email_key" ON "Driver"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Driver_contactNumber_key" ON "Driver"("contactNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Admin_username_key" ON "Admin"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Admin_email_key" ON "Admin"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AdminDriverRelation_adminId_driverId_key" ON "AdminDriverRelation"("adminId", "driverId");

-- CreateIndex
CREATE UNIQUE INDEX "Availability_driverId_jobId_key" ON "Availability"("driverId", "jobId");

-- CreateIndex
CREATE UNIQUE INDEX "JobDriverAccess_jobId_driverId_key" ON "JobDriverAccess"("jobId", "driverId");

-- AddForeignKey
ALTER TABLE "DriverRanking" ADD CONSTRAINT "DriverRanking_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminDriverRelation" ADD CONSTRAINT "AdminDriverRelation_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Admin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminDriverRelation" ADD CONSTRAINT "AdminDriverRelation_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Job" ADD CONSTRAINT "Job_assignedDriverId_fkey" FOREIGN KEY ("assignedDriverId") REFERENCES "Driver"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Availability" ADD CONSTRAINT "Availability_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Availability" ADD CONSTRAINT "Availability_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("jobId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobDriverAccess" ADD CONSTRAINT "JobDriverAccess_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("jobId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JobDriverAccess" ADD CONSTRAINT "JobDriverAccess_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
