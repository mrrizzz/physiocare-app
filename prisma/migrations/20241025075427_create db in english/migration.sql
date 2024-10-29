/*
  Warnings:

  - The values [pasien,dokter/terapis,admin/kasir] on the enum `Role` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `id_profil` on the `Account` table. All the data in the column will be lost.
  - You are about to drop the column `aktif` on the `Staff` table. All the data in the column will be lost.
  - You are about to drop the column `id_posisi` on the `Staff` table. All the data in the column will be lost.
  - You are about to drop the column `id_profil` on the `Staff` table. All the data in the column will be lost.
  - You are about to drop the column `tanggal_bergabung` on the `Staff` table. All the data in the column will be lost.
  - You are about to drop the `Anamnesa` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `CatatanLayanan` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `DetailResep` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `InventarisMedis` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Layanan` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Pembayaran` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Penjadwalan` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Posisi` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Profil` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Resep` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Staff_Layanan` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[profile_id]` on the table `Account` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `profile_id` to the `Account` table without a default value. This is not possible if the table is not empty.
  - Added the required column `join_date` to the `Staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `position_id` to the `Staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `profile_id` to the `Staff` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ProfileType" AS ENUM ('staff', 'patient');

-- CreateEnum
CREATE TYPE "Session" AS ENUM ('morning', 'afternoon', 'evening');

-- CreateEnum
CREATE TYPE "SchedulingStatus" AS ENUM ('scheduled', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "InventoryType" AS ENUM ('medication', 'assistive device', 'other');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('pending', 'paid', 'cancelled');

-- AlterEnum
BEGIN;
CREATE TYPE "Role_new" AS ENUM ('patient', 'doctor/therapist', 'admin/cashier', 'owner');
ALTER TABLE "Account" ALTER COLUMN "role" TYPE "Role_new" USING ("role"::text::"Role_new");
ALTER TYPE "Role" RENAME TO "Role_old";
ALTER TYPE "Role_new" RENAME TO "Role";
DROP TYPE "Role_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Account" DROP CONSTRAINT "Account_id_profil_fkey";

-- DropForeignKey
ALTER TABLE "Anamnesa" DROP CONSTRAINT "Anamnesa_id_pasien_fkey";

-- DropForeignKey
ALTER TABLE "Anamnesa" DROP CONSTRAINT "Anamnesa_id_penjadwalan_fkey";

-- DropForeignKey
ALTER TABLE "CatatanLayanan" DROP CONSTRAINT "CatatanLayanan_id_anamnesa_fkey";

-- DropForeignKey
ALTER TABLE "CatatanLayanan" DROP CONSTRAINT "CatatanLayanan_id_penjadwalan_fkey";

-- DropForeignKey
ALTER TABLE "DetailResep" DROP CONSTRAINT "DetailResep_id_inventaris_medis_fkey";

-- DropForeignKey
ALTER TABLE "DetailResep" DROP CONSTRAINT "DetailResep_id_resep_fkey";

-- DropForeignKey
ALTER TABLE "Pembayaran" DROP CONSTRAINT "Pembayaran_id_catatan_layanan_fkey";

-- DropForeignKey
ALTER TABLE "Penjadwalan" DROP CONSTRAINT "Penjadwalan_id_layanan_fkey";

-- DropForeignKey
ALTER TABLE "Penjadwalan" DROP CONSTRAINT "Penjadwalan_id_pasien_fkey";

-- DropForeignKey
ALTER TABLE "Penjadwalan" DROP CONSTRAINT "Penjadwalan_id_staff_fkey";

-- DropForeignKey
ALTER TABLE "Resep" DROP CONSTRAINT "Resep_id_catatan_layanan_fkey";

-- DropForeignKey
ALTER TABLE "Staff" DROP CONSTRAINT "Staff_id_posisi_fkey";

-- DropForeignKey
ALTER TABLE "Staff" DROP CONSTRAINT "Staff_id_profil_fkey";

-- DropForeignKey
ALTER TABLE "Staff_Layanan" DROP CONSTRAINT "Staff_Layanan_id_layanan_fkey";

-- DropForeignKey
ALTER TABLE "Staff_Layanan" DROP CONSTRAINT "Staff_Layanan_id_staff_fkey";

-- DropIndex
DROP INDEX "Account_id_profil_key";

-- AlterTable
ALTER TABLE "Account" DROP COLUMN "id_profil",
ADD COLUMN     "profile_id" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Staff" DROP COLUMN "aktif",
DROP COLUMN "id_posisi",
DROP COLUMN "id_profil",
DROP COLUMN "tanggal_bergabung",
ADD COLUMN     "active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "join_date" DATE NOT NULL,
ADD COLUMN     "position_id" INTEGER NOT NULL,
ADD COLUMN     "profile_id" INTEGER NOT NULL;

-- DropTable
DROP TABLE "Anamnesa";

-- DropTable
DROP TABLE "CatatanLayanan";

-- DropTable
DROP TABLE "DetailResep";

-- DropTable
DROP TABLE "InventarisMedis";

-- DropTable
DROP TABLE "Layanan";

-- DropTable
DROP TABLE "Pembayaran";

-- DropTable
DROP TABLE "Penjadwalan";

-- DropTable
DROP TABLE "Posisi";

-- DropTable
DROP TABLE "Profil";

-- DropTable
DROP TABLE "Resep";

-- DropTable
DROP TABLE "Staff_Layanan";

-- DropEnum
DROP TYPE "JenisInventaris";

-- DropEnum
DROP TYPE "Sesi";

-- DropEnum
DROP TYPE "StatusPembayaran";

-- DropEnum
DROP TYPE "StatusPenjadwalan";

-- DropEnum
DROP TYPE "TipeProfil";

-- CreateTable
CREATE TABLE "Profile" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "dob" DATE,
    "gender" VARCHAR(10),
    "address" TEXT,
    "phone" VARCHAR(20),
    "type" "ProfileType" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "max_salary" INTEGER NOT NULL,
    "min_salary" INTEGER NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "price" INTEGER NOT NULL,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StaffService" (
    "staff_id" INTEGER NOT NULL,
    "service_id" INTEGER NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE,

    CONSTRAINT "StaffService_pkey" PRIMARY KEY ("staff_id","service_id","start_date")
);

-- CreateTable
CREATE TABLE "Scheduling" (
    "id" SERIAL NOT NULL,
    "staff_id" INTEGER NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "service_id" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "session" "Session" NOT NULL,
    "status" "SchedulingStatus" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Scheduling_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MedicalRecord" (
    "id" SERIAL NOT NULL,
    "scheduling_id" INTEGER NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "complaint" TEXT,
    "medical_history" TEXT,
    "physical_examination" TEXT,
    "systolic" INTEGER,
    "diastolic" INTEGER,
    "heart_rate" INTEGER,
    "respiratory_rate" INTEGER,
    "temperature" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "MedicalRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ServiceNote" (
    "id" SERIAL NOT NULL,
    "scheduling_id" INTEGER NOT NULL,
    "medical_record_id" INTEGER NOT NULL,
    "additional_notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "ServiceNote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Prescription" (
    "id" SERIAL NOT NULL,
    "service_note_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Prescription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PrescriptionDetail" (
    "id" SERIAL NOT NULL,
    "prescription_id" INTEGER NOT NULL,
    "medical_inventory_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "dosage_instructions" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "PrescriptionDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MedicalInventory" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "price" DECIMAL(12,2) NOT NULL,
    "stock" INTEGER NOT NULL,
    "type" "InventoryType" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "MedicalInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" SERIAL NOT NULL,
    "service_note_id" INTEGER NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "payment_method" VARCHAR(50),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Scheduling_staff_id_date_session_key" ON "Scheduling"("staff_id", "date", "session");

-- CreateIndex
CREATE UNIQUE INDEX "Account_profile_id_key" ON "Account"("profile_id");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff" ADD CONSTRAINT "Staff_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff" ADD CONSTRAINT "Staff_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StaffService" ADD CONSTRAINT "StaffService_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "Staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StaffService" ADD CONSTRAINT "StaffService_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "Staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_scheduling_id_fkey" FOREIGN KEY ("scheduling_id") REFERENCES "Scheduling"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServiceNote" ADD CONSTRAINT "ServiceNote_scheduling_id_fkey" FOREIGN KEY ("scheduling_id") REFERENCES "Scheduling"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServiceNote" ADD CONSTRAINT "ServiceNote_medical_record_id_fkey" FOREIGN KEY ("medical_record_id") REFERENCES "MedicalRecord"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prescription" ADD CONSTRAINT "Prescription_service_note_id_fkey" FOREIGN KEY ("service_note_id") REFERENCES "ServiceNote"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrescriptionDetail" ADD CONSTRAINT "PrescriptionDetail_prescription_id_fkey" FOREIGN KEY ("prescription_id") REFERENCES "Prescription"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrescriptionDetail" ADD CONSTRAINT "PrescriptionDetail_medical_inventory_id_fkey" FOREIGN KEY ("medical_inventory_id") REFERENCES "MedicalInventory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_service_note_id_fkey" FOREIGN KEY ("service_note_id") REFERENCES "ServiceNote"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
