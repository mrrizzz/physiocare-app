/*
  Warnings:

  - Added the required column `harga` to the `Layanan` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nama` to the `Layanan` table without a default value. This is not possible if the table is not empty.
  - Added the required column `max_gaji` to the `Posisi` table without a default value. This is not possible if the table is not empty.
  - Added the required column `min_gaji` to the `Posisi` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nama` to the `Posisi` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Layanan" ADD COLUMN     "harga" INTEGER NOT NULL,
ADD COLUMN     "nama" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Posisi" ADD COLUMN     "max_gaji" INTEGER NOT NULL,
ADD COLUMN     "min_gaji" INTEGER NOT NULL,
ADD COLUMN     "nama" TEXT NOT NULL;
