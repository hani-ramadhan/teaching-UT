-- Query baca TUWEB 03. Jalankan setelah 00-siapkan-lab.sql.
USE tuweb02;

-- Q01
SELECT id_pasien, nama_pasien
FROM t3_pasien
ORDER BY id_pasien;

-- Q02
SELECT id_pasien, nama_pasien
FROM t3_pasien
WHERE jenis_kelamin = 'L'
ORDER BY id_pasien;

-- Q03
SELECT id_pasien, nama_pasien
FROM t3_pasien
WHERE id_pasien BETWEEN 1 AND 2
ORDER BY id_pasien;

-- Q04
SELECT id_pasien, nama_pasien
FROM t3_pasien
WHERE nama_pasien LIKE '%B%'
ORDER BY id_pasien;

-- Q05
SELECT id_pasien,
       LEFT(alamat_pasien, 2) AS awalan,
       RIGHT(alamat_pasien, 1) AS nomor,
       MID(alamat_pasien, 5, 6) AS potongan
FROM t3_pasien
ORDER BY id_pasien;

-- Q06
SELECT id_pasien, nama_pasien
FROM t3_pasien
ORDER BY id_pasien DESC;

-- Q07
SELECT pd.id, p.nama_pasien, pd.waktu_periksa,
       pd.resep, d.nama_dokter
FROM t3_pasien AS p
JOIN t3_pasien_dokter AS pd ON pd.id_pasien = p.id_pasien
JOIN t3_dokter AS d ON d.id_dokter = pd.id_dokter
ORDER BY pd.id;

-- Q08
SELECT pd.id, p.nama_pasien, d.nama_dokter
FROM t3_pasien AS p
JOIN t3_pasien_dokter AS pd ON pd.id_pasien = p.id_pasien
JOIN t3_dokter AS d ON d.id_dokter = pd.id_dokter
WHERE d.id_dokter = 1
ORDER BY pd.id;

-- Q09
SELECT p.id_pasien, p.nama_pasien
FROM t3_pasien AS p
LEFT JOIN t3_pasien_dokter AS pd ON pd.id_pasien = p.id_pasien
WHERE pd.id IS NULL
ORDER BY p.id_pasien;

-- Q10
SELECT COUNT(*) AS jumlah_pemeriksaan,
       COUNT(DISTINCT id_pasien) AS pasien_diperiksa
FROM t3_pasien_dokter;

-- Q11
SELECT jenis_kelamin, COUNT(*) AS jumlah_pasien
FROM t3_pasien
GROUP BY jenis_kelamin
ORDER BY jenis_kelamin;

-- Q12
SELECT p.id_pasien, p.nama_pasien, COUNT(pd.id) AS jumlah_periksa
FROM t3_pasien AS p
LEFT JOIN t3_pasien_dokter AS pd ON pd.id_pasien = p.id_pasien
GROUP BY p.id_pasien, p.nama_pasien
ORDER BY p.id_pasien;

-- Q13
SELECT p.id_pasien, p.nama_pasien, COUNT(pd.id) AS jumlah_periksa
FROM t3_pasien AS p
LEFT JOIN t3_pasien_dokter AS pd ON pd.id_pasien = p.id_pasien
GROUP BY p.id_pasien, p.nama_pasien
HAVING COUNT(pd.id) >= 2
ORDER BY p.id_pasien;

-- Q14
SELECT SUM(saldo) AS total_saldo,
       MIN(saldo) AS saldo_terkecil,
       MAX(saldo) AS saldo_terbesar
FROM t3_rekening;
