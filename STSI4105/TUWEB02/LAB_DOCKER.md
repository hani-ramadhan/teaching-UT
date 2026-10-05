# Lab TUWEB 02 - MariaDB dalam Docker

## 1. Pilihan lingkungan

| Alat | Peran | Status |
| --- | --- | --- |
| yEd Live | Menggambar dan menjelaskan ERD | Utama |
| Docker dan Compose | Menjalankan lingkungan lab | Utama |
| MariaDB 11.4 | DBMS untuk SQL | Utama |
| phpMyAdmin 5.2 | Antarmuka web untuk SQL/struktur tabel | Opsional, profil `gui` |
| XAMPP | Alternatif lingkungan sesuai panduan UT | Tidak diperlukan pada alur Docker |

MariaDB 11.4 dipilih sebagai seri pemeliharaan panjang. Tag seri dapat memperoleh patch baru; paket ini tidak mengunci digest image. Jalankan persiapan dan uji sebelum kelas. Rancangan ditujukan untuk lab lokal.

## 2. Persiapan

Pastikan Docker berjalan dan perintah berikut tersedia:

```bash
docker version
docker compose version
```

Gunakan Compose v2 yang mendukung `up --wait`. Jika opsi itu belum tersedia, jalankan `up -d` lalu periksa kesiapan melalui `docker compose ps`.

Salin `.env.example` menjadi `.env`:

**PowerShell:**

```powershell
Copy-Item .env.example .env
```

**Bash:**

```bash
cp .env.example .env
```

Isi dua password pada `.env`. `.env.example` hanya berisi contoh lab; `.env` dikecualikan oleh `.gitignore`.

## 3. Jalankan MariaDB

Dari folder yang berisi `compose.yaml`:

```bash
docker compose up -d --wait db
docker compose ps
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Masukkan password `MARIADB_PASSWORD`. Periksa:

```sql
SELECT VERSION();
SELECT DATABASE();
SHOW TABLES;
SELECT COUNT(*) AS jumlah_pasien FROM pasien;
SELECT COUNT(*) AS jumlah_pemeriksaan FROM pasien_dokter;
```

Pada kondisi awal, jumlah pasien 3 dan pemeriksaan 4. Ada sepuluh tabel: enam tabel rumah sakit dan empat tabel faktur.

Folder `sql/init` dipasang ke `/docker-entrypoint-initdb.d`. Skrip init dijalankan saat volume database pertama kali dibuat. Perubahan skrip init tidak otomatis dijalankan pada volume lama.

## 4. phpMyAdmin opsional

```bash
docker compose --profile gui up -d --wait
```

Buka [http://localhost:8080](http://localhost:8080). Gunakan pengguna `mahasiswa` dan password pada `.env`. Pilih database `tuweb02`, lalu jalankan SQL pada area SQL.

| Lokasi koneksi | Host | Port | Database |
| --- | --- | --- | --- |
| Klien pada komputer mahasiswa | `127.0.0.1` | `3307` atau nilai DB_PORT | `tuweb02` |
| phpMyAdmin di jaringan Compose | `db` | `3306` | `tuweb02` |
| Terminal dalam container db | Koneksi lokal container | Socket lokal/default | `tuweb02` |

`db` adalah nama service pada jaringan Compose. `localhost` di container phpMyAdmin menunjuk ke container itu sendiri, sehingga PMA_HOST memakai `db`.

## 5. Jalankan demo SQL

### Cara lintas sistem operasi

Salin berkas ke container:

```bash
docker compose cp sql/demo/01-ddl-dml.sql db:/tmp/01-ddl-dml.sql
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Di terminal MariaDB:

```sql
SOURCE /tmp/01-ddl-dml.sql;
```

Untuk mengajar, lebih baik jalankan isi berkas tahap demi tahap agar kondisi sebelum/sesudah dapat dijelaskan. Berkas demo DDL/DML hanya membuat ulang dan menghapus `pasien_demo`; tabel kasus tidak dihapus.

Untuk pratinjau faktur:

```bash
docker compose cp sql/demo/02-faktur-preview.sql db:/tmp/02-faktur-preview.sql
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Lalu:

```sql
SOURCE /tmp/02-faktur-preview.sql;
```

Hasil yang diharapkan: tiga baris detail; total F001 35000.00 dan F002 9000.00.

## 6. Hentikan dan mulai lagi

Menghentikan service tanpa menghapus data:

```bash
docker compose --profile gui stop
```

Menghapus container dan jaringan dengan data volume tetap ada:

```bash
docker compose --profile gui down
```

Mulai lagi dengan `docker compose up -d --wait db` atau aktifkan profil GUI. Data pada named volume dipertahankan.

### Membuat ulang data awal

**Perintah berikut menghapus volume database lab ini.** Gunakan hanya jika hasil latihan pada volume sudah tidak diperlukan atau sudah dicadangkan.

```bash
docker compose --profile gui down -v
docker compose up -d --wait db
```

Init kemudian dijalankan pada volume baru. Nama project Compose adalah `tuweb02`; jangan memakai nama project yang sama untuk beberapa lab terpisah yang perlu dipertahankan sekaligus.

## 7. Cadangan data

Cara ini menghindari perbedaan pengalihan output antara Bash dan versi PowerShell. Dump dibuat di container lalu disalin ke komputer. Jalankan shell container:

```bash
docker compose exec db sh
```

Di shell tersebut:

```sh
mariadb-dump -u mahasiswa -p --single-transaction --no-tablespaces tuweb02 > /tmp/tuweb02.sql
exit
```

Jangan mengubah struktur tabel saat dump berlangsung. Buat folder `backups` pada komputer, lalu:

```bash
docker compose cp db:/tmp/tuweb02.sql backups/tuweb02.sql
```

Folder `backups` dikecualikan dari Git. Untuk restore ke database lab, salin dump kembali ke container dan jalankan `SOURCE` pada terminal MariaDB setelah memeriksa database tujuan.

## 8. Masalah umum

| Gejala | Pemeriksaan |
| --- | --- |
| `docker` tidak ditemukan | Pastikan Docker terpasang, berjalan, dan terminal dapat menemukannya |
| Gagal menghubungi Docker daemon | Jalankan Docker, lalu ulangi `docker version` |
| Port 3307/8080 sudah dipakai | Ubah DB_PORT/PMA_PORT pada `.env`, kemudian jalankan kembali Compose |
| `.env` belum berisi password | Isi variabel yang disebut pada pesan Compose |
| Access denied setelah mengubah `.env` | Password pada volume lama tidak otomatis berubah; gunakan password lama atau lakukan perubahan akun melalui DBMS |
| Tabel tidak muncul | Periksa database aktif dan apakah volume dibuat sebelum skrip init ditambahkan |
| phpMyAdmin tidak dapat terhubung | Periksa service db sehat; PMA_HOST harus `db`, port internal 3306 |
| Container unhealthy | Periksa `docker compose logs db`; baca galat init atau startup |
| Tabel pasien_demo sudah ada | Untuk mengulang latihan, gunakan skrip demo yang membuat ulang hanya tabel demo tersebut |
| Database uji dan XAMPP tertukar | Catat host dan port; lab Docker memakai port host 3307 secara default |

## 9. Jika perlu memakai XAMPP

Paket ini memakai MariaDB dan phpMyAdmin langsung dalam container. Untuk AB 1-7, tidak perlu menjalankan web server PHP aplikasi atau memasang XAMPP tambahan.

Jika mahasiswa harus memakai XAMPP mengikuti panduan kelas:

1. Gunakan lingkungan itu sebagai alternatif.
2. Buat database `tuweb02` pada DBMS yang dipilih.
3. Jalankan dua skrip `sql/init` secara berurutan pada database tersebut.
4. Samakan nama kolom dan data contoh.
5. Catat versi serta koneksi yang digunakan; jangan menganggap data pada Docker dan XAMPP adalah database yang sama.

Docker merupakan penyesuaian lingkungan praktik. Ketentuan tugas serta pelaporan tetap mengikuti kelas.

## 10. Rujukan teknis

- [MariaDB 11.4 Changes & Improvements](https://mariadb.com/docs/release-notes/community-server/11.4/what-is-mariadb-114).
- [MariaDB Docker Official Image](https://github.com/MariaDB/mariadb-docker).
- [MariaDB image initialization documentation](https://github.com/docker-library/docs/blob/master/mariadb/content.md).
- [Using Healthcheck](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh).
- [Compose services](https://docs.docker.com/reference/compose-file/services/).
- [Compose profiles](https://docs.docker.com/compose/how-tos/profiles/).
- [phpMyAdmin Docker image](https://github.com/phpmyadmin/docker).
