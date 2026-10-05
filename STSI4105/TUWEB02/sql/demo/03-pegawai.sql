-- Contoh penghubung ke kasus pegawai pada slide AK07.
USE tuweb02;
CREATE TABLE IF NOT EXISTS pegawai_demo (
  id_pegawai INT NOT NULL PRIMARY KEY,
  tanggal_lahir DATE NOT NULL,
  nama VARCHAR(50) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL
) ENGINE=InnoDB;
-- Gunakan ID khusus demo; pengulangan tidak menggandakan baris.
INSERT INTO pegawai_demo VALUES (9001, '1995-01-01', 'Pegawai Contoh', 'P')
ON DUPLICATE KEY UPDATE nama = VALUES(nama);
SELECT * FROM pegawai_demo WHERE id_pegawai = 9001;
