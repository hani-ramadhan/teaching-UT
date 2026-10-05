-- Pengayaan: jembatan ke JOIN pada TUWEB 03, bukan syarat AB 7.
USE tuweb02;
SELECT f.no_faktur, f.tanggal, s.nama_supplier, b.nama_barang,
       t.jumlah, t.harga_transaksi, t.jumlah * t.harga_transaksi AS subtotal
FROM faktur AS f
JOIN supplier AS s ON s.kode_supplier = f.kode_supplier
JOIN transaksi AS t ON t.no_faktur = f.no_faktur
JOIN barang AS b ON b.kode_barang = t.kode_barang
ORDER BY f.no_faktur, b.kode_barang;

SELECT no_faktur, SUM(jumlah * harga_transaksi) AS total_faktur
FROM transaksi
GROUP BY no_faktur
ORDER BY no_faktur;
