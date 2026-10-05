-- Jalankan pada database tuweb02. Tabel demo terpisah dari pasien sumber.
USE tuweb02;
-- Untuk pengulangan demo, hanya tabel pasien_demo yang dibuat ulang.
DROP TABLE IF EXISTS pasien_demo;
CREATE TABLE pasien_demo (
  id_pasien INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL
) ENGINE=InnoDB;

INSERT INTO pasien_demo (nama_pasien, alamat_pasien, jenis_kelamin)
VALUES ('Pasien Demo', 'Jl. Contoh 10', 'L');
SELECT * FROM pasien_demo;

SELECT * FROM pasien_demo WHERE id_pasien = 1;
UPDATE pasien_demo SET alamat_pasien = 'Jl. Contoh 20' WHERE id_pasien = 1;
SELECT * FROM pasien_demo WHERE id_pasien = 1;

ALTER TABLE pasien_demo ADD COLUMN no_hp VARCHAR(20);
CREATE INDEX idx_pasien_demo_nama ON pasien_demo (nama_pasien);
SHOW CREATE TABLE pasien_demo;
DROP INDEX idx_pasien_demo_nama ON pasien_demo;

DELETE FROM pasien_demo WHERE id_pasien = 1;
SELECT COUNT(*) AS sisa_baris FROM pasien_demo;
-- Tabel tetap ada setelah DELETE. Akhiri contoh DDL dengan DROP TABLE.
DROP TABLE pasien_demo;
