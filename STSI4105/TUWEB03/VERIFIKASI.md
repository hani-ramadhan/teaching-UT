# Pemeriksaan materi TUWEB 03

Tanggal pemeriksaan: 19 Oktober 2026.

## Pemeriksaan yang selesai

| Pemeriksaan | Hasil |
| --- | --- |
| Cakupan empat PDF terbaru | AB 7 sebagai pengulangan; Panduan Praktikum SQL sebagai AB 8; AB 9 transaksi; AB 10 distribusi |
| Kesesuaian AB 8-11 pada RAT | AB 11 tetap dimuat; panduan VirtualBox dari unggahan sebelumnya ditandai sebagai sumber tambahan |
| Halaman strategi distribusi yang berupa gambar | Ditinjau secara visual; lima strategi dicakup dalam pembahasan |
| Alokasi waktu | Sembilan blok bersambung dari menit 00 sampai 90; total 90 menit |
| Tautan berkas relatif dan pasangan pagar kode Markdown | Lulus |
| Kesesuaian potongan query utama dengan berkas SQL | Lulus |
| Q01-Q14: filter, string, JOIN, agregasi, GROUP BY, HAVING | Hasil sesuai prediksi melalui adaptasi SQLite |
| INSERT/UPDATE/DELETE, keadaan sebelum dan setelah ROLLBACK | Hasil sesuai prediksi melalui adaptasi SQLite |
| Transfer batal dan sukses, jumlah baris debit/kredit, total saldo | Hasil sesuai prediksi melalui adaptasi SQLite |
| Persiapan ulang data t3_, tabel lama tanpa awalan tetap ada | Lulus melalui adaptasi SQLite |
| Penolakan FK tidak valid, DELETE RESTRICT, dan saldo negatif | Lulus melalui adaptasi SQLite |
| `git diff --check` | Lulus sebelum publikasi |

## Batas pengujian

Pemeriksaan query memakai SQLite dalam memori dengan penyesuaian sintaks MariaDB: USE/ENGINE/AUTO_INCREMENT dihilangkan, START TRANSACTION menjadi BEGIN, ROW_COUNT menjadi changes, dan LEFT/RIGHT/MID menjadi substr. Ini memeriksa hasil relasional dan logika perubahan data pada contoh, **bukan bukti eksekusi MariaDB 11.4**. Perilaku tipe data, kolasi, mode SQL, implicit commit DDL, dan penguncian tidak disamakan dengan SQLite.

Docker/Rancher Desktop serta MariaDB 11.4 tidak tersedia untuk menjalankan paket container di lingkungan pemeriksaan. Demo dua koneksi, timeout/deadlock InnoDB, persistensi volume, tampilan phpMyAdmin, VirtualBox/Ubuntu, dan jaringan VM belum diuji langsung di sini. Penjelasan perilakunya diperiksa terhadap dokumentasi teknis yang ditautkan pada materi. Tidak ada replikasi aktif yang dikonfigurasi oleh paket ini.

## Uji lokal sebelum tutorial

1. Mulai server dari folder TUWEB02, lalu salin folder SQL sesuai README.
2. Pada koneksi MariaDB, jalankan `SOURCE /tmp/tuweb03-sql/00-siapkan-lab.sql;`. Periksa 3 pasien, 4 pemeriksaan, dan total saldo 150000.00.
3. Jalankan query 01: Q07 harus 4 baris, Q09 Pasien C, Q10 bernilai 4/2, Q12 bernilai 3/1/0, Q13 hanya Pasien A dengan jumlah 3.
4. Jalankan demo 02. Setelah ROLLBACK, tabel t3_pasien_demo harus kosong.
5. Jalankan demo 03 bertahap. Setelah pembatalan saldo 100000/50000; setelah COMMIT saldo 75000/75000; total 150000.
6. Buka dua koneksi dengan ID berbeda. Ikuti urutan demo kunci pada materi: B menunggu dan mendapat ERROR 1205 setelah sekitar 5 detik; ROLLBACK pada B dan A; saldo tetap 100000/50000.
7. Pastikan semua transaksi ditutup. Lakukan persiapan ulang hanya jika hasil latihan t3_ sudah tidak diperlukan.
8. Periksa VM, sistem operasi guest, adapter jaringan, IP, serta koneksi sebelum sesi. Gunakan data fiktif dan hindari menampilkan password saat merekam.

## Tambahan: alternatif Docker dan phpMyAdmin

Panduan alternatif dan konfigurasi ditambahkan pada 19 Oktober 2026. Pemeriksaan statis mencakup sintaks YAML, jalur skrip init, pemisahan dua volume, port host yang berbeda, profil node kedua, dependensi kesehatan node A, serta daftar server phpMyAdmin yang selaras. Semua tautan lokal dan alokasi 90 menit diperiksa kembali. Skrip init memakai berkas 00 yang hasil relasionalnya telah diperiksa sebagaimana dicatat di atas.

Startup satu/dua node, variabel lingkungan pada image yang ditarik, formulir login phpMyAdmin, eksekusi blok SQL pada web, dan koneksi antarnode belum dijalankan langsung pada Docker di sini. Jalur alternatif ini belum merupakan konfigurasi replikasi.

Sebelum kelas, dari folder `docker-alternatif`, siapkan `.env`, jalankan `docker compose config --quiet`, kemudian `docker compose up -d --wait`. Periksa Node A pada port web 8081 dan hasil hitung awal. Aktifkan `docker compose --profile dua-node up -d --wait`, lalu periksa Node B, perbedaan hostname, pemisahan data, dan koneksi SQL A ke B sesuai panduan. Tutup seluruh transaksi dan pulihkan perubahan contoh setelah demo.
