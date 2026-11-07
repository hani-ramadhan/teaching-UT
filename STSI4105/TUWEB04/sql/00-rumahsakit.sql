-- TUWEB 04: siapkan tabel InnoDB dan data contoh sebelum praktikum.
-- Untuk impor manual, pilih server 1 - Primary di phpMyAdmin.
-- Impor ulang menambah data contoh yang belum ada dan mempertahankan baris lama.

CREATE DATABASE IF NOT EXISTS rumahsakit;
USE rumahsakit;

-- Buat tabel induk sebelum tabel yang memiliki foreign key.
CREATE TABLE IF NOT EXISTS pasien (
  id_pasien INT NOT NULL AUTO_INCREMENT,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL,
  PRIMARY KEY (id_pasien)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS obat (
  id_obat INT NOT NULL AUTO_INCREMENT,
  kode_obat VARCHAR(5) NOT NULL,
  nama_obat VARCHAR(30) NOT NULL,
  harga INT NOT NULL CHECK (harga >= 0),
  stok INT NOT NULL CHECK (stok >= 0),
  PRIMARY KEY (id_obat),
  UNIQUE (kode_obat)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transaksi_obat (
  id_transaksi INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_obat INT NOT NULL,
  jumlah INT NOT NULL CHECK (jumlah > 0),
  total_harga INT NOT NULL CHECK (total_harga >= 0),
  PRIMARY KEY (id_transaksi),
  FOREIGN KEY (id_pasien) REFERENCES pasien (id_pasien),
  FOREIGN KEY (id_obat) REFERENCES obat (id_obat)
) ENGINE=InnoDB;

-- Tambahkan pasien dan obat awal. Mahasiswa mengisi transaksi_obat saat praktik.
START TRANSACTION;

INSERT INTO pasien (id_pasien, nama_pasien, alamat_pasien, jenis_kelamin)
SELECT contoh.id_pasien, contoh.nama_pasien, contoh.alamat_pasien, contoh.jenis_kelamin
FROM (
  SELECT 1 AS id_pasien, 'Pasien A' AS nama_pasien,
         'Jl. Contoh 1' AS alamat_pasien, 'L' AS jenis_kelamin
  UNION ALL SELECT 2, 'Pasien B', 'Jl. Contoh 2', 'P'
  UNION ALL SELECT 3, 'Pasien C', 'Jl. Contoh 3', 'L'
) AS contoh
LEFT JOIN pasien AS tersimpan ON tersimpan.id_pasien = contoh.id_pasien
WHERE tersimpan.id_pasien IS NULL;

INSERT INTO obat (id_obat, kode_obat, nama_obat, harga, stok)
SELECT contoh.id_obat, contoh.kode_obat, contoh.nama_obat, contoh.harga, contoh.stok
FROM (
  SELECT 1 AS id_obat, 'A001' AS kode_obat, 'Amikacin' AS nama_obat,
         20000 AS harga, 10 AS stok
  UNION ALL SELECT 2, 'A002', 'Amoxillin', 15000, 20
  UNION ALL SELECT 3, 'A003', 'Betadine', 7000, 5
) AS contoh
LEFT JOIN obat AS tersimpan
  ON tersimpan.id_obat = contoh.id_obat OR tersimpan.kode_obat = contoh.kode_obat
WHERE tersimpan.id_obat IS NULL;

COMMIT;
