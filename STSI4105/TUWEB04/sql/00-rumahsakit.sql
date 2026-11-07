USE rumahsakit;

CREATE TABLE pasien (
  id_pasien INT NOT NULL AUTO_INCREMENT,
  nama_pasien VARCHAR(50) NOT NULL,
  alamat_pasien VARCHAR(100) NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL,
  PRIMARY KEY (id_pasien)
) ENGINE=InnoDB;

CREATE TABLE obat (
  id_obat INT NOT NULL AUTO_INCREMENT,
  kode_obat VARCHAR(5) NOT NULL,
  nama_obat VARCHAR(30) NOT NULL,
  harga INT NOT NULL CHECK (harga >= 0),
  stok INT NOT NULL CHECK (stok >= 0),
  PRIMARY KEY (id_obat),
  UNIQUE (kode_obat)
) ENGINE=InnoDB;

CREATE TABLE transaksi_obat (
  id_transaksi INT NOT NULL AUTO_INCREMENT,
  id_pasien INT NOT NULL,
  id_obat INT NOT NULL,
  jumlah INT NOT NULL CHECK (jumlah > 0),
  total_harga INT NOT NULL CHECK (total_harga >= 0),
  PRIMARY KEY (id_transaksi),
  FOREIGN KEY (id_pasien) REFERENCES pasien (id_pasien),
  FOREIGN KEY (id_obat) REFERENCES obat (id_obat)
) ENGINE=InnoDB;

INSERT INTO pasien (id_pasien, nama_pasien, alamat_pasien, jenis_kelamin) VALUES
  (1, 'Pasien A', 'Jl. Contoh 1', 'L'),
  (2, 'Pasien B', 'Jl. Contoh 2', 'P'),
  (3, 'Pasien C', 'Jl. Contoh 3', 'L');

INSERT INTO obat (id_obat, kode_obat, nama_obat, harga, stok) VALUES
  (1, 'A001', 'Amikacin', 20000, 10),
  (2, 'A002', 'Amoxillin', 15000, 20),
  (3, 'A003', 'Betadine', 7000, 5);
