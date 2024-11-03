/*
  Warnings:

  - The values [medicine,aid,other] on the enum `InventoryType` will be removed. If these variants are still used in the database, this will fail.
  - The values [pending,paid,cancelled] on the enum `PaymentStatus` will be removed. If these variants are still used in the database, this will fail.
  - The values [patient,medics,officer,owner] on the enum `Role` will be removed. If these variants are still used in the database, this will fail.
  - The values [scheduled,completed,cancelled] on the enum `SchedulingStatus` will be removed. If these variants are still used in the database, this will fail.
  - The values [morning,afternoon,evening] on the enum `Session` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `type` on the `Profile` table. All the data in the column will be lost.
  - The primary key for the `StaffService` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[name]` on the table `Position` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `Service` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[profile_id]` on the table `Staff` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[staff_id,service_id,start_date]` on the table `StaffService` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateEnum
CREATE TYPE "StaffType" AS ENUM ('ADMIN', 'DOCTOR', 'OWNER');

-- AlterEnum
BEGIN;
CREATE TYPE "InventoryType_new" AS ENUM ('MEDICINE', 'AID', 'OTHER');
ALTER TABLE "MedicalInventory" ALTER COLUMN "type" TYPE "InventoryType_new" USING ("type"::text::"InventoryType_new");
ALTER TYPE "InventoryType" RENAME TO "InventoryType_old";
ALTER TYPE "InventoryType_new" RENAME TO "InventoryType";
DROP TYPE "InventoryType_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "PaymentStatus_new" AS ENUM ('PENDING', 'PAID', 'CANCELLED');
ALTER TABLE "Payment" ALTER COLUMN "status" TYPE "PaymentStatus_new" USING ("status"::text::"PaymentStatus_new");
ALTER TYPE "PaymentStatus" RENAME TO "PaymentStatus_old";
ALTER TYPE "PaymentStatus_new" RENAME TO "PaymentStatus";
DROP TYPE "PaymentStatus_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "Role_new" AS ENUM ('STAFF', 'PATIENT');
ALTER TABLE "Account" ALTER COLUMN "role" TYPE "Role_new" USING ("role"::text::"Role_new");
ALTER TYPE "Role" RENAME TO "Role_old";
ALTER TYPE "Role_new" RENAME TO "Role";
DROP TYPE "Role_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "SchedulingStatus_new" AS ENUM ('WAITING', 'SCHEDULED', 'COMPLETED', 'CANCELLED');
ALTER TABLE "Scheduling" ALTER COLUMN "status" TYPE "SchedulingStatus_new" USING ("status"::text::"SchedulingStatus_new");
ALTER TYPE "SchedulingStatus" RENAME TO "SchedulingStatus_old";
ALTER TYPE "SchedulingStatus_new" RENAME TO "SchedulingStatus";
DROP TYPE "SchedulingStatus_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "Session_new" AS ENUM ('MORNING', 'AFTERNOON', 'EVENING');
ALTER TABLE "Scheduling" ALTER COLUMN "session" TYPE "Session_new" USING ("session"::text::"Session_new");
ALTER TYPE "Session" RENAME TO "Session_old";
ALTER TYPE "Session_new" RENAME TO "Session";
DROP TYPE "Session_old";
COMMIT;

-- AlterTable
ALTER TABLE "Profile" DROP COLUMN "type";

-- AlterTable
ALTER TABLE "Staff" ADD COLUMN     "salary" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "type" "StaffType" NOT NULL DEFAULT 'DOCTOR';

-- AlterTable
ALTER TABLE "StaffService" DROP CONSTRAINT "StaffService_pkey",
ADD COLUMN     "active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "StaffService_pkey" PRIMARY KEY ("id");

-- DropEnum
DROP TYPE "ProfileType";

-- CreateIndex
CREATE UNIQUE INDEX "Position_name_key" ON "Position"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Service_name_key" ON "Service"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Staff_profile_id_key" ON "Staff"("profile_id");

-- CreateIndex
CREATE UNIQUE INDEX "StaffService_staff_id_service_id_start_date_key" ON "StaffService"("staff_id", "service_id", "start_date");
