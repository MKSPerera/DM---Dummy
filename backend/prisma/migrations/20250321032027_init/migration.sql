-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('ADMIN_ONLY', 'DRIVER_ONLY', 'BOTH');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('UNREAD', 'READ');

-- AlterTable
ALTER TABLE "Admin" ADD COLUMN     "fcmToken" TEXT;

-- AlterTable
ALTER TABLE "Driver" ADD COLUMN     "fcmToken" TEXT;

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "driverId" INTEGER,
    "adminId" INTEGER,
    "status" "NotificationStatus" NOT NULL DEFAULT 'UNREAD',
    "jobId" INTEGER,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("jobId") ON DELETE SET NULL ON UPDATE CASCADE;
