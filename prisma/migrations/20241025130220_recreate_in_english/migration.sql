/*
  Warnings:

  - The values [medication,assistive device] on the enum `InventoryType` will be removed. If these variants are still used in the database, this will fail.
  - The values [doctor/therapist,admin/cashier] on the enum `Role` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "InventoryType_new" AS ENUM ('medicine', 'aid', 'other');
ALTER TABLE "MedicalInventory" ALTER COLUMN "type" TYPE "InventoryType_new" USING ("type"::text::"InventoryType_new");
ALTER TYPE "InventoryType" RENAME TO "InventoryType_old";
ALTER TYPE "InventoryType_new" RENAME TO "InventoryType";
DROP TYPE "InventoryType_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "Role_new" AS ENUM ('patient', 'medics', 'officer', 'owner');
ALTER TABLE "Account" ALTER COLUMN "role" TYPE "Role_new" USING ("role"::text::"Role_new");
ALTER TYPE "Role" RENAME TO "Role_old";
ALTER TYPE "Role_new" RENAME TO "Role";
DROP TYPE "Role_old";
COMMIT;

-- AlterTable
ALTER TABLE "Profile" ADD COLUMN     "age" INTEGER;
