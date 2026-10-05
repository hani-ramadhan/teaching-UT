-- Skema pendamping: nama tabel mengikuti panduan praktik UT.
-- NOT NULL dan ON DELETE RESTRICT merupakan keputusan lab tutor.
-- Pasangan dokter-pasien boleh memiliki beberapa pemeriksaan.
USE tuweb02;

CREATE TABLE pasien (
  id_pasien INT NOT NULL AUTO_INCREMENT,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL,
  PRIMARY KEY (id_pasien)
) ENGINE=InnoDB;

CREATE TABLE dokter (
  id_dokter INT NOT NULL AUTO_INCREMENT,
  nama_dokter VARCHAR(50) NOT NULL,
  spesialis VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_dokter)
) ENGINE=InnoDB;

CREATE TABLE administrator (
  id_admin INT NOT NULL AUTO_INCREMENT,
  nama_admin VARCHAR(50) NOT NULL,
  waktu_jaga VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_admin)
) ENGINE=InnoDB;

CREATE TABLE pasien_dokter (
  id INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_dokter INT NOT NULL,
  waktu_periksa DATE NOT NULL,
  resep VARCHAR(100),
  PRIMARY KEY (id),
  CONSTRAINT fk_periksa_pasien FOREIGN KEY (id_pasien)
    REFERENCES pasien (id_pasien) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_periksa_dokter FOREIGN KEY (id_dokter)
    REFERENCES dokter (id_dokter) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE daftar (
  id_daftar INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_admin INT NOT NULL,
  PRIMARY KEY (id_daftar),
  CONSTRAINT fk_daftar_pasien FOREIGN KEY (id_pasien)
    REFERENCES pasien (id_pasien) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_daftar_admin FOREIGN KEY (id_admin)
    REFERENCES administrator (id_admin) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE dokter_admin (
  id_data INT NOT NULL AUTO_INCREMENT,
  id_dokter INT NOT NULL,
  id_admin INT NOT NULL,
  PRIMARY KEY (id_data),
  CONSTRAINT fk_data_dokter FOREIGN KEY (id_dokter)
    REFERENCES dokter (id_dokter) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_data_admin FOREIGN KEY (id_admin)
    REFERENCES administrator (id_admin) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO pasien (id_pasien, nama_pasien, alamat_pasien, jenis_kelamin) VALUES
  (1, 'Pasien A', 'Jl. Contoh 1', 'L'),
  (2, 'Pasien B', 'Jl. Contoh 2', 'P'),
  (3, 'Pasien C', 'Jl. Contoh 3', 'L');
INSERT INTO dokter (id_dokter, nama_dokter, spesialis) VALUES
  (1, 'Dokter A', 'Umum'), (2, 'Dokter B', 'Anak');
INSERT INTO administrator (id_admin, nama_admin, waktu_jaga) VALUES
  (1, 'Admin A', 'Pagi'), (2, 'Admin B', 'Sore');
INSERT INTO pasien_dokter (id, id_pasien, id_dokter, waktu_periksa, resep) VALUES
  (1, 1, 1, '2026-10-01', 'Catatan contoh 1'),
  (2, 1, 2, '2026-10-02', 'Catatan contoh 2'),
  (3, 2, 1, '2026-10-02', 'Catatan contoh 3'),
  (4, 1, 1, '2026-10-03', 'Catatan contoh 4');
INSERT INTO daftar (id_daftar, id_pasien, id_admin) VALUES
  (1, 1, 1), (2, 2, 1), (3, 3, 2);
INSERT INTO dokter_admin (id_data, id_dokter, id_admin) VALUES
  (1, 1, 1), (2, 2, 1), (3, 1, 2);
