-- Jalankan bertahap pada SATU koneksi CLI, tanpa sesi penguncian lain.
-- Skrip mengembalikan saldo latihan ke 100000/50000 terlebih dahulu.
USE tuweb02;
SET SESSION autocommit = 1;
UPDATE t3_rekening SET saldo = CASE id_rekening
  WHEN 1 THEN 100000.00 WHEN 2 THEN 50000.00 END
WHERE id_rekening IN (1, 2);
SELECT * FROM t3_rekening ORDER BY id_rekening;

-- Demo pembatalan: debit tanpa kredit, lalu batalkan seluruh transaksi.
START TRANSACTION;
UPDATE t3_rekening SET saldo = saldo - 25000.00 WHERE id_rekening = 1;
SELECT * FROM t3_rekening ORDER BY id_rekening;
-- Dalam sesi ini terlihat 75000/50000. Jangan COMMIT keadaan ini.
ROLLBACK;
SELECT * FROM t3_rekening ORDER BY id_rekening;
-- Kembali 100000/50000.

-- Demo sukses. Data awal menjamin kedua rekening ada dan saldo mencukupi.
START TRANSACTION;
UPDATE t3_rekening SET saldo = saldo - 25000.00
WHERE id_rekening = 1 AND saldo >= 25000.00;
SELECT ROW_COUNT() AS baris_debit;
-- Harus 1. Jika 0 atau muncul galat: ROLLBACK; jangan lanjutkan kredit.
UPDATE t3_rekening SET saldo = saldo + 25000.00 WHERE id_rekening = 2;
SELECT ROW_COUNT() AS baris_kredit;
-- Harus 1. Aplikasi nyata perlu percabangan dan penanganan galat.
SELECT * FROM t3_rekening ORDER BY id_rekening;
SELECT SUM(saldo) AS total_saldo FROM t3_rekening;
COMMIT;
SELECT * FROM t3_rekening ORDER BY id_rekening;
-- Akhir 75000/75000; total tetap 150000.
