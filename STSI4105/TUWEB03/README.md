# TUWEB 03 - Basis Data STSI4105

Panduan pendamping **90 menit**, mencakup AB 8-11 sesuai pembagian TUWEB. AB 7 menjadi pengulangan SQL, lalu dilanjutkan praktik SQL rumah sakit, manajemen transaksi, konsep basis data terdistribusi, dan pengantar VirtualBox.

Mulai dari [pembahasan lengkap TUWEB 03](TUWEB03_Basis_Data.md).

| Kebutuhan | Berkas |
| --- | --- |
| Materi, alokasi waktu, demo, latihan, kunci, dan rujukan halaman PDF | [TUWEB03_Basis_Data.md](TUWEB03_Basis_Data.md) |
| Data latihan terpisah dengan awalan `t3_` | [00-siapkan-lab.sql](sql/00-siapkan-lab.sql) |
| SELECT, filter, string, JOIN, agregasi, GROUP BY, HAVING | [01-query.sql](sql/01-query.sql) |
| INSERT, UPDATE, DELETE, dan pembatalan | [02-dml.sql](sql/02-dml.sql) |
| Transfer contoh: ROLLBACK dan COMMIT | [03-transaksi.sql](sql/03-transaksi.sql) |
| Penguncian dua sesi dan pengantar VirtualBox | Langkah bertahap pada materi utama |
| Jika VirtualBox tidak tersedia | [Panduan alternatif Docker dan phpMyAdmin](ALTERNATIF_DOCKER_PHPMYADMIN.md) |
| Lab mandiri, satu atau dua instance MariaDB | [Compose alternatif](docker-alternatif/compose.yaml), [.env.example](docker-alternatif/.env.example) |
| Hasil pemeriksaan dan batas pengujian | [VERIFIKASI.md](VERIFIKASI.md) |

## Mulai cepat

Pakai server MariaDB dari [TUWEB 02](../TUWEB02/README.md). Rancher Desktop memakai engine **dockerd (moby)**. Jika `.env` belum ada, ikuti [persiapan lab](../TUWEB02/LAB_DOCKER.md) terlebih dahulu.

Dari root repository, PowerShell atau Bash:

```sh
cd STSI4105/TUWEB02
docker compose up -d --wait db
docker compose cp ../TUWEB03/sql db:/tmp/tuweb03-sql
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Pada prompt MariaDB:

```sql
SOURCE /tmp/tuweb03-sql/00-siapkan-lab.sql;
SOURCE /tmp/tuweb03-sql/01-query.sql;
```

Skrip 00 **menghapus dan membuat ulang tabel latihan TUWEB 03 yang disebut di dalamnya**. Jalankan sebelum kelas, setelah seluruh transaksi/sesi latihan selesai. Ia tidak mengubah tabel TUWEB 02 tanpa awalan `t3_`. Hasil awal: 3 pasien, 4 pemeriksaan, total saldo 150000.00.

Demo DML dapat dijalankan dengan `SOURCE /tmp/tuweb03-sql/02-dml.sql;`. Untuk mengamati transfer, jalankan isi berkas 03 tahap demi tahap pada satu koneksi CLI. Ikuti instruksi pada komentar sebelum COMMIT; contoh ini bukan fungsi transfer produksi.

Untuk phpMyAdmin, jalankan `docker compose --profile gui up -d --wait`, buka http://localhost:8080, lalu pilih `tuweb02`. Gunakan CLI untuk transaksi bertahap dan dua sesi.

## Batas cakupan

VirtualBox tetap dibahas sesuai RAT AB 11. Jika tidak tersedia, gunakan [alternatif Docker dan phpMyAdmin](ALTERNATIF_DOCKER_PHPMYADMIN.md). Pilihan ini mencakup server lama atau paket mandiri, query melalui web, transaksi melalui CLI, serta dua instance opsional. Demo alternatif memakai blok 7 menit yang sama sehingga durasi tetap 90 menit. Bukti Docker menunjukkan lingkungan alternatif; ketentuan bukti tugas resmi mengikuti kelas.

Replikasi aktif dan praktik distribusi penuh dilanjutkan pada TUWEB 04/AB 12. Data, pertanyaan, dan contoh tambahan tutor ditandai pada materi. Instalasi penuh dan pengunduhan image dilakukan sebelum/di luar sesi.
