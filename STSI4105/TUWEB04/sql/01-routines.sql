USE rumahsakit;

-- Muat berkas ini sebelum memulai transaksi demo. DDL dapat melakukan commit implisit.
DROP PROCEDURE IF EXISTS transaksi1;
DROP PROCEDURE IF EXISTS transaksi2;
DROP PROCEDURE IF EXISTS transaksi3;
DROP PROCEDURE IF EXISTS transaksi4;
DROP PROCEDURE IF EXISTS transaksi5;

DELIMITER //

CREATE PROCEDURE transaksi1()
BEGIN
  START TRANSACTION;
  INSERT INTO pasien VALUES (101, 'Pasien Demo', 'Jl. Lab 1', 'L');
  -- Pemanggil memeriksa hasil dan menutup transaksi dengan ROLLBACK.
END//

CREATE PROCEDURE transaksi2()
BEGIN
  START TRANSACTION;
  INSERT INTO pasien VALUES (101, 'Pasien Demo', 'Jl. Lab 1', 'L');
  COMMIT;
END//

CREATE PROCEDURE transaksi3()
BEGIN
  START TRANSACTION;
  UPDATE pasien SET nama_pasien = 'Danar' WHERE id_pasien = 3;
  ROLLBACK;
END//

CREATE PROCEDURE transaksi4()
BEGIN
  START TRANSACTION;
  INSERT INTO pasien VALUES (102, 'Pasien Batal', 'Jl. Lab 2', 'P');
  ROLLBACK;

  START TRANSACTION;
  UPDATE pasien SET nama_pasien = 'Septin' WHERE id_pasien = 3;
  COMMIT;
END//

CREATE PROCEDURE transaksi5()
BEGIN
  START TRANSACTION;
  INSERT INTO pasien VALUES (103, 'Pasien Satu', 'Jl. Lab 3', 'L');
  SAVEPOINT point1;
  INSERT INTO pasien VALUES (104, 'Pasien Dua', 'Jl. Lab 4', 'P');
  ROLLBACK TO SAVEPOINT point1;
  INSERT INTO pasien VALUES (105, 'Pasien Tiga', 'Jl. Lab 5', 'L');
  COMMIT;
END//

DELIMITER ;
