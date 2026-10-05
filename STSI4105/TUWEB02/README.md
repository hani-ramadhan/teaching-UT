# TUWEB 02 - Basis Data STSI4105

Materi pendamping **AB 1-7**, untuk tutorial **90 menit**.

Mulai dari [pembahasan TUWEB 02](TUWEB02_Basis_Data.md). Materi berisi konsep, contoh yang dibahas, latihan, kunci diskusi, dan alokasi waktu.

| Kebutuhan | Berkas atau alat |
| --- | --- |
| Pembahasan utama | [TUWEB02_Basis_Data.md](TUWEB02_Basis_Data.md) |
| ERD secara langsung | [yEd Live](https://www.yworks.com/yed-live/) |
| Diagram rumah sakit | [rumahsakit.graphml](diagrams/rumahsakit.graphml) |
| Diagram faktur 3NF | [faktur-3nf.graphml](diagrams/faktur-3nf.graphml) |
| Server basis data | [compose.yaml](compose.yaml), MariaDB 11.4 |
| Antarmuka web opsional | phpMyAdmin, profil Compose `gui` |
| Tabel dan data awal | [sql/init](sql/init) |
| SQL untuk demonstrasi | [sql/demo](sql/demo) |
| Persiapan, operasi, dan masalah lab | [LAB_DOCKER.md](LAB_DOCKER.md) |
| Pemeriksaan berkas dan uji lokal yang diperlukan | [VERIFIKASI.md](VERIFIKASI.md) |

## Mulai cepat

Pastikan Docker dan Compose tersedia. Salin `.env.example` menjadi `.env`, lalu isi password khusus lab lokal.

**PowerShell:**

```powershell
Copy-Item .env.example .env
docker compose up -d --wait db
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

**Bash:**

```bash
cp .env.example .env
docker compose up -d --wait db
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Masukkan password `MARIADB_PASSWORD` saat diminta. Untuk antarmuka web:

```bash
docker compose --profile gui up -d --wait
```

Buka [phpMyAdmin lokal](http://localhost:8080). Login dengan pengguna `mahasiswa` dan password pada `.env`. Jalankan `SHOW TABLES;` setelah memilih database `tuweb02`.

Untuk membuka diagram, buka yEd Live dan impor berkas GraphML dari folder `diagrams`. Ikuti penjelasan kardinalitas dalam materi utama.

## Cakupan

TUWEB 02 membahas konsep dan SQL dasar. JOIN lengkap, agregasi, transaksi, dan replikasi menjadi pembahasan TUWEB berikutnya. Query faktur pada paket ini merupakan pratinjau opsional.

Contoh narasi serta data telah disusun ulang sebagai bahan tutor. Semua nama pasien dan pegawai pada lab adalah data fiktif. PDF sumber UT tidak disertakan dalam paket.

XAMPP tidak diperlukan untuk jalur Docker ini. Panduan perbandingan dengan lingkungan XAMPP ada di [LAB_DOCKER.md](LAB_DOCKER.md).
