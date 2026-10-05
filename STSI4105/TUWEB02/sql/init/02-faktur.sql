-- Contoh normalisasi tambahan tutor, mengikuti pola kasus faktur pada AK05.
-- Asumsi: satu kode_barang paling banyak sekali dalam satu faktur.
USE tuweb02;

CREATE TABLE supplier (
  kode_supplier CHAR(3) NOT NULL PRIMARY KEY,
  nama_supplier VARCHAR(50) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE barang (
  kode_barang CHAR(3) NOT NULL PRIMARY KEY,
  nama_barang VARCHAR(50) NOT NULL,
  harga_daftar DECIMAL(12,2) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE faktur (
  no_faktur CHAR(4) NOT NULL PRIMARY KEY,
  tanggal DATE NOT NULL,
  kode_supplier CHAR(3) NOT NULL,
  CONSTRAINT fk_faktur_supplier FOREIGN KEY (kode_supplier)
    REFERENCES supplier (kode_supplier) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
CREATE TABLE transaksi (
  no_faktur CHAR(4) NOT NULL,
  kode_barang CHAR(3) NOT NULL,
  jumlah INT NOT NULL,
  harga_transaksi DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (no_faktur, kode_barang),
  CONSTRAINT fk_detail_faktur FOREIGN KEY (no_faktur)
    REFERENCES faktur (no_faktur) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_detail_barang FOREIGN KEY (kode_barang)
    REFERENCES barang (kode_barang) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO supplier VALUES ('S01', 'Pemasok Contoh');
INSERT INTO barang VALUES
  ('B01', 'Buku Tulis', 10000.00), ('B02', 'Pulpen', 5000.00);
INSERT INTO faktur VALUES
  ('F001', '2026-10-01', 'S01'), ('F002', '2026-10-02', 'S01');
INSERT INTO transaksi VALUES
  ('F001', 'B01', 2, 10000.00),
  ('F001', 'B02', 3, 5000.00),
  ('F002', 'B01', 1, 9000.00);
