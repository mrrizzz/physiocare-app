-- CreateEnum
CREATE TYPE "Role" AS ENUM ('pasien', 'dokter/terapis', 'admin/kasir', 'owner');

-- CreateEnum
CREATE TYPE "TipeProfil" AS ENUM ('staff', 'pasien');

-- CreateEnum
CREATE TYPE "Sesi" AS ENUM ('pagi', 'siang', 'sore');

-- CreateEnum
CREATE TYPE "StatusPenjadwalan" AS ENUM ('terjadwal', 'selesai', 'batal');

-- CreateEnum
CREATE TYPE "JenisInventaris" AS ENUM ('obat', 'alat bantu', 'lainnya');

-- CreateEnum
CREATE TYPE "StatusPembayaran" AS ENUM ('pending', 'lunas', 'batal');

-- CreateTable
CREATE TABLE "Account" (
    "id" SERIAL NOT NULL,
    "id_profil" INTEGER NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "role" "Role" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profil" (
    "id" SERIAL NOT NULL,
    "nama" VARCHAR(100) NOT NULL,
    "ttl" DATE,
    "jenis_kelamin" VARCHAR(10),
    "alamat" TEXT,
    "no_hp" VARCHAR(20),
    "tipe" "TipeProfil" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Profil_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Staff" (
    "id" SERIAL NOT NULL,
    "id_profil" INTEGER NOT NULL,
    "id_posisi" INTEGER NOT NULL,
    "tanggal_bergabung" DATE NOT NULL,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Staff_Layanan" (
    "id_staff" INTEGER NOT NULL,
    "id_layanan" INTEGER NOT NULL,
    "tanggal_mulai" DATE NOT NULL,
    "tanggal_selesai" DATE,

    CONSTRAINT "Staff_Layanan_pkey" PRIMARY KEY ("id_staff","id_layanan","tanggal_mulai")
);

-- CreateTable
CREATE TABLE "Penjadwalan" (
    "id" SERIAL NOT NULL,
    "id_staff" INTEGER NOT NULL,
    "id_pasien" INTEGER NOT NULL,
    "id_layanan" INTEGER NOT NULL,
    "tanggal" DATE NOT NULL,
    "sesi" "Sesi" NOT NULL,
    "status" "StatusPenjadwalan" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Penjadwalan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Anamnesa" (
    "id" SERIAL NOT NULL,
    "id_penjadwalan" INTEGER NOT NULL,
    "id_pasien" INTEGER NOT NULL,
    "keluhan" TEXT,
    "riwayat_penyakit" TEXT,
    "pemeriksaan_fisik" TEXT,
    "sistol" INTEGER,
    "diastol" INTEGER,
    "detak_nadi" INTEGER,
    "frekuensi_pernapasan" INTEGER,
    "suhu" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Anamnesa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CatatanLayanan" (
    "id" SERIAL NOT NULL,
    "id_penjadwalan" INTEGER NOT NULL,
    "id_anamnesa" INTEGER NOT NULL,
    "penunjang_keterangan" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "CatatanLayanan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Resep" (
    "id" SERIAL NOT NULL,
    "id_catatan_layanan" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Resep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DetailResep" (
    "id" SERIAL NOT NULL,
    "id_resep" INTEGER NOT NULL,
    "id_inventaris_medis" INTEGER NOT NULL,
    "jumlah" INTEGER NOT NULL,
    "dosis_cara_pakai" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "DetailResep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventarisMedis" (
    "id" SERIAL NOT NULL,
    "nama" VARCHAR(100) NOT NULL,
    "deskripsi" TEXT,
    "harga" DECIMAL(12,2) NOT NULL,
    "stok" INTEGER NOT NULL,
    "jenis" "JenisInventaris" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "InventarisMedis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pembayaran" (
    "id" SERIAL NOT NULL,
    "id_catatan_layanan" INTEGER NOT NULL,
    "jumlah_bayar" DECIMAL(12,2) NOT NULL,
    "status" "StatusPembayaran" NOT NULL,
    "metode_pembayaran" VARCHAR(50),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "Pembayaran_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Posisi" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "Posisi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Layanan" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "Layanan_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_id_profil_key" ON "Account"("id_profil");

-- CreateIndex
CREATE UNIQUE INDEX "Account_username_key" ON "Account"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Account_email_key" ON "Account"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Penjadwalan_id_staff_tanggal_sesi_key" ON "Penjadwalan"("id_staff", "tanggal", "sesi");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_id_profil_fkey" FOREIGN KEY ("id_profil") REFERENCES "Profil"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff" ADD CONSTRAINT "Staff_id_profil_fkey" FOREIGN KEY ("id_profil") REFERENCES "Profil"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff" ADD CONSTRAINT "Staff_id_posisi_fkey" FOREIGN KEY ("id_posisi") REFERENCES "Posisi"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff_Layanan" ADD CONSTRAINT "Staff_Layanan_id_staff_fkey" FOREIGN KEY ("id_staff") REFERENCES "Staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Staff_Layanan" ADD CONSTRAINT "Staff_Layanan_id_layanan_fkey" FOREIGN KEY ("id_layanan") REFERENCES "Layanan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Penjadwalan" ADD CONSTRAINT "Penjadwalan_id_staff_fkey" FOREIGN KEY ("id_staff") REFERENCES "Staff"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Penjadwalan" ADD CONSTRAINT "Penjadwalan_id_pasien_fkey" FOREIGN KEY ("id_pasien") REFERENCES "Profil"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Penjadwalan" ADD CONSTRAINT "Penjadwalan_id_layanan_fkey" FOREIGN KEY ("id_layanan") REFERENCES "Layanan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Anamnesa" ADD CONSTRAINT "Anamnesa_id_penjadwalan_fkey" FOREIGN KEY ("id_penjadwalan") REFERENCES "Penjadwalan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Anamnesa" ADD CONSTRAINT "Anamnesa_id_pasien_fkey" FOREIGN KEY ("id_pasien") REFERENCES "Profil"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CatatanLayanan" ADD CONSTRAINT "CatatanLayanan_id_penjadwalan_fkey" FOREIGN KEY ("id_penjadwalan") REFERENCES "Penjadwalan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CatatanLayanan" ADD CONSTRAINT "CatatanLayanan_id_anamnesa_fkey" FOREIGN KEY ("id_anamnesa") REFERENCES "Anamnesa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Resep" ADD CONSTRAINT "Resep_id_catatan_layanan_fkey" FOREIGN KEY ("id_catatan_layanan") REFERENCES "CatatanLayanan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DetailResep" ADD CONSTRAINT "DetailResep_id_resep_fkey" FOREIGN KEY ("id_resep") REFERENCES "Resep"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DetailResep" ADD CONSTRAINT "DetailResep_id_inventaris_medis_fkey" FOREIGN KEY ("id_inventaris_medis") REFERENCES "InventarisMedis"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pembayaran" ADD CONSTRAINT "Pembayaran_id_catatan_layanan_fkey" FOREIGN KEY ("id_catatan_layanan") REFERENCES "CatatanLayanan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
