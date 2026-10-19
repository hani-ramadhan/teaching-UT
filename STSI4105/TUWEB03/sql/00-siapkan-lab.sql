-- Persiapan TUWEB 03. Jalankan SEBELUM kelas dan setelah semua sesi selesai.
-- Menghapus/membuat ulang HANYA tabel t3_ yang disebut di bawah.
-- Data tabel TUWEB 02 tanpa awalan t3_ tidak diubah.
USE tuweb02;
DROP TABLE IF EXISTS t3_pasien_demo;
DROP TABLE IF EXISTS t3_pasien_dokter;
DROP TABLE IF EXISTS t3_dokter_admin;
DROP TABLE IF EXISTS t3_daftar;
DROP TABLE IF EXISTS t3_pasien;
DROP TABLE IF EXISTS t3_dokter;
DROP TABLE IF EXISTS t3_administrator;
DROP TABLE IF EXISTS t3_rekening;


CREATE TABLE t3_pasien (
  id_pasien INT NOT NULL AUTO_INCREMENT,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL,
  PRIMARY KEY (id_pasien)
) ENGINE=InnoDB;

CREATE TABLE t3_dokter (
  id_dokter INT NOT NULL AUTO_INCREMENT,
  nama_dokter VARCHAR(50) NOT NULL,
  spesialis VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_dokter)
) ENGINE=InnoDB;

CREATE TABLE t3_administrator (
  id_admin INT NOT NULL AUTO_INCREMENT,
  nama_admin VARCHAR(50) NOT NULL,
  waktu_jaga VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_admin)
) ENGINE=InnoDB;

CREATE TABLE t3_pasien_dokter (
  id INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_dokter INT NOT NULL,
  waktu_periksa DATE NOT NULL,
  resep VARCHAR(100),
  PRIMARY KEY (id),
  CONSTRAINT fk_t3_periksa_pasien FOREIGN KEY (id_pasien)
    REFERENCES t3_pasien (id_pasien) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_t3_periksa_dokter FOREIGN KEY (id_dokter)
    REFERENCES t3_dokter (id_dokter) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE t3_daftar (
  id_daftar INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_admin INT NOT NULL,
  PRIMARY KEY (id_daftar),
  CONSTRAINT fk_t3_daftar_pasien FOREIGN KEY (id_pasien)
    REFERENCES t3_pasien (id_pasien) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_t3_daftar_admin FOREIGN KEY (id_admin)
    REFERENCES t3_administrator (id_admin) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE t3_dokter_admin (
  id_data INT NOT NULL AUTO_INCREMENT,
  id_dokter INT NOT NULL,
  id_admin INT NOT NULL,
  PRIMARY KEY (id_data),
  CONSTRAINT fk_t3_data_dokter FOREIGN KEY (id_dokter)
    REFERENCES t3_dokter (id_dokter) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_t3_data_admin FOREIGN KEY (id_admin)
    REFERENCES t3_administrator (id_admin) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO t3_pasien (id_pasien, nama_pasien, alamat_pasien, jenis_kelamin) VALUES
  (1, 'Pasien A', 'Jl. Contoh 1', 'L'),
  (2, 'Pasien B', 'Jl. Contoh 2', 'P'),
  (3, 'Pasien C', 'Jl. Contoh 3', 'L');
INSERT INTO t3_dokter (id_dokter, nama_dokter, spesialis) VALUES
  (1, 'Dokter A', 'Umum'), (2, 'Dokter B', 'Anak');
INSERT INTO t3_administrator (id_admin, nama_admin, waktu_jaga) VALUES
  (1, 'Admin A', 'Pagi'), (2, 'Admin B', 'Sore');
INSERT INTO t3_pasien_dokter (id, id_pasien, id_dokter, waktu_periksa, resep) VALUES
  (1, 1, 1, '2026-10-01', 'Catatan contoh 1'),
  (2, 1, 2, '2026-10-02', 'Catatan contoh 2'),
  (3, 2, 1, '2026-10-02', 'Catatan contoh 3'),
  (4, 1, 1, '2026-10-03', 'Catatan contoh 4');
INSERT INTO t3_daftar (id_daftar, id_pasien, id_admin) VALUES
  (1, 1, 1), (2, 2, 1), (3, 3, 2);
INSERT INTO t3_dokter_admin (id_data, id_dokter, id_admin) VALUES
  (1, 1, 1), (2, 2, 1), (3, 1, 2);

-- Rekening fiktif sebagai ilustrasi transaksi, bukan data medis/keuangan nyata.
CREATE TABLE t3_rekening (
  id_rekening INT NOT NULL PRIMARY KEY,
  pemilik VARCHAR(30) NOT NULL,
  saldo DECIMAL(12,2) NOT NULL,
  CONSTRAINT ck_t3_saldo CHECK (saldo >= 0)
) ENGINE=InnoDB;
INSERT INTO t3_rekening VALUES (1, 'A', 100000.00), (2, 'B', 50000.00);

SELECT COUNT(*) AS jumlah_pasien FROM t3_pasien;
SELECT COUNT(*) AS jumlah_pemeriksaan FROM t3_pasien_dokter;
SELECT SUM(saldo) AS total_saldo FROM t3_rekening;
