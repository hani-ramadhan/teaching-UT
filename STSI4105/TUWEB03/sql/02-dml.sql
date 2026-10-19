-- Demo INSERT, UPDATE, DELETE yang dapat diulang.
-- DDL dikerjakan di luar transaksi DML. Tabel t3_pasien utama tidak diubah.
USE tuweb02;
CREATE TABLE IF NOT EXISTS t3_pasien_demo (
  id_pasien INT NOT NULL PRIMARY KEY,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL
) ENGINE=InnoDB;

START TRANSACTION;
INSERT INTO t3_pasien_demo VALUES
  (91, 'Pasien Latihan', 'Jl. Latihan 1', 'L'),
  (92, 'Pasien Uji', 'Jl. Latihan 2', 'P');
SELECT * FROM t3_pasien_demo ORDER BY id_pasien;
-- Prediksi dulu baris yang berubah sebelum menjalankan UPDATE.
SELECT * FROM t3_pasien_demo WHERE id_pasien = 92;
UPDATE t3_pasien_demo SET nama_pasien = 'Pasien Uji Revisi'
WHERE id_pasien = 92;
DELETE FROM t3_pasien_demo WHERE id_pasien = 91;
SELECT * FROM t3_pasien_demo ORDER BY id_pasien;
-- Sebelum ROLLBACK: hanya ID 92, nama Pasien Uji Revisi.
ROLLBACK;
SELECT COUNT(*) AS sisa_baris FROM t3_pasien_demo;
-- Setelah ROLLBACK: 0 pada tabel demo yang disiapkan paket ini.
