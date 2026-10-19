# Alternatif VirtualBox: Docker dan phpMyAdmin untuk TUWEB 03

Gunakan jalur ini jika VirtualBox tidak tersedia, tidak dapat dipasang, atau VM tidak dapat dijalankan. SQL tetap memakai **MariaDB 11.4**, sedangkan **phpMyAdmin** menyediakan antarmuka web. Rancher Desktop menjadi lingkungan container lokal.

Tujuan alternatif ini adalah agar mahasiswa tetap dapat berlatih SQL, transaksi, dan mengenali beberapa instance basis data. Bukti container tidak membuktikan pemasangan VirtualBox/Ubuntu yang disebut pada RAT AB 11. Untuk penilaian resmi, ikuti bentuk bukti yang ditetapkan tutor/kelas.

## 1. Pilih lingkungan

| Pilihan | Gunakan ketika | Database / akses web |
| --- | --- | --- |
| A. Server TUWEB 02 yang sudah berjalan | Hanya perlu melanjutkan praktik SQL dengan antarmuka web | `tuweb02`, http://localhost:8080 |
| B. Paket alternatif mandiri | Perlu lab terpisah atau simulasi dua node tanpa VirtualBox | `tuweb02` pada server baru, http://localhost:8081 |

Pilih satu jalur untuk praktik agar hasil tidak tertukar. Nama database `tuweb02` dipertahankan supaya seluruh skrip TUWEB 03 dapat dipakai tanpa perubahan. Pada pilihan B, database itu berada di server/volume terpisah dari pilihan A.

### Pilihan A: pakai lab lama

Dari root repository:

```sh
cd STSI4105/TUWEB02
docker compose --profile gui up -d --wait
docker compose cp ../TUWEB03/sql db:/tmp/tuweb03-sql
docker compose exec db mariadb -u mahasiswa -p tuweb02
```

Pada CLI MariaDB, jalankan `SOURCE /tmp/tuweb03-sql/00-siapkan-lab.sql;` jika data TUWEB 03 belum disiapkan. Skrip ini membuat ulang tabel latihan `t3_`; jalankan sebelum kelas setelah transaksi lain selesai. Buka http://localhost:8080, login sebagai `mahasiswa` dengan password `.env` TUWEB02, lalu pilih `tuweb02`.

Lanjutkan cara memakai tab SQL/Import pada Bagian 4. Untuk demo penguncian, gunakan perintah CLI pada materi utama. Jalur A hanya satu server; jika perlu dua node, gunakan pilihan B berikut.

## 2. Pilihan B: persiapan paket mandiri

Pastikan repository sudah diperbarui dengan `git pull` dari root repository. Buka Rancher Desktop, pilih **Preferences > Container Engine > dockerd (moby)**, lalu tunggu sampai siap. Kubernetes tidak diperlukan untuk lab ini.

Buka PowerShell pada root repository:

```powershell
cd STSI4105\TUWEB03\docker-alternatif
docker version
docker compose version
Copy-Item .env.example .env
notepad .env
```

Untuk Bash, gunakan `cd STSI4105/TUWEB03/docker-alternatif` dan `cp .env.example .env`, lalu sunting `.env` dengan editor Anda. Salin hanya pada penggunaan pertama; jangan menimpa konfigurasi lama.

Ganti kedua password pada `.env`. Port awal paket ini:

| Layanan | Dari komputer pengguna | Dari container pada jaringan paket |
| --- | --- | --- |
| MariaDB node A | `127.0.0.1:3308` | `db-a:3306` |
| MariaDB node B, opsional | `127.0.0.1:3309` | `db-b:3306` |
| phpMyAdmin | http://localhost:8081 | Aplikasi web pada port container 80 |

Project Compose bernama `tuweb03-alt`. Volumenya terpisah untuk node A dan B. Port tersebut berbeda dari default TUWEB 02. Jika port sudah digunakan, ubah `ALT_DB_A_PORT`, `ALT_DB_B_PORT`, atau `ALT_PMA_PORT` pada `.env` dan gunakan nilai baru pada koneksi.

## 3. Jalankan satu node dan phpMyAdmin

Dari folder `docker-alternatif`:

```sh
docker compose config --quiet
docker compose up -d --wait
docker compose ps
```

Perintah pertama memeriksa konfigurasi tanpa mencetak hasil interpolasi password. Jika `--wait` belum didukung, gunakan `up -d`, lalu pantau `docker compose ps` sampai `db-a` healthy.

Pada volume baru, image MariaDB membuat database `tuweb02` dan akun `mahasiswa`, lalu menjalankan **hanya** `sql/00-siapkan-lab.sql` yang dipasang sebagai skrip init. Query 01 dan demo perubahan/transfer tidak dijalankan otomatis.

Buka http://localhost:8081. Pada formulir login pilih **Node A**, isi pengguna `mahasiswa`, dan gunakan `MARIADB_PASSWORD` dari `.env` pada folder ini. Pilihan Node B baru dapat digunakan setelah profil `dua-node` diaktifkan.

Pilih database `tuweb02`, buka tab **SQL**, lalu jalankan:

```sql
SELECT @@hostname AS node, DATABASE() AS database_aktif;
SELECT COUNT(*) AS jumlah_pasien FROM t3_pasien;
SELECT COUNT(*) AS jumlah_pemeriksaan FROM t3_pasien_dokter;
SELECT SUM(saldo) AS total_saldo FROM t3_rekening;
```

Pada data awal, node A bernama `tuweb03-db-a`; jumlah pasien = 3; jumlah pemeriksaan = 4; total saldo = 150000.00. Ada tujuh tabel latihan `t3_`. Tabel `t3_pasien_demo` baru dibuat oleh demo DML.

Jika server sudah mempunyai volume dari penggunaan sebelumnya, init tidak diulang. Mengubah skrip atau password `.env` juga tidak otomatis mengubah isi volume dan akun lama.

## 4. Praktik lewat phpMyAdmin

### 4.1 Query dan pemeriksaan struktur

1. Pastikan server dan database yang dipilih benar.
2. Klik tabel untuk meninjau **Browse/Jelajahi** dan **Structure/Struktur**.
3. Buka tab **SQL** untuk menjalankan satu query dari [01-query.sql](sql/01-query.sql).
4. Bandingkan hasil dengan materi utama. Q07 menghasilkan 4 pemeriksaan; Q09 menghasilkan Pasien C; Q12 menghasilkan jumlah 3/1/0.
5. Untuk latihan JOIN/HAVING, tulis sendiri query sebelum melihat kunci.

Nama menu dapat berbeda menurut bahasa antarmuka. phpMyAdmin adalah klien administrasi; data disimpan oleh MariaDB, bukan oleh browser.

### 4.2 Import skrip

Pada database `tuweb02`, pilih **Import**, pilih berkas SQL dari komputer, pastikan format SQL, lalu jalankan. Anda dapat mengimpor:

| Berkas | Kegunaan | Catatan |
| --- | --- | --- |
| `01-query.sql` | Seluruh query baca | Jalankan query satu per satu untuk diskusi hasil |
| `02-dml.sql` | INSERT/UPDATE/DELETE dan ROLLBACK | Setelah selesai, tabel demo kosong |
| `00-siapkan-lab.sql` | Membuat ulang data latihan | Menghapus hasil latihan pada tabel `t3_` yang disebut skrip; gunakan setelah semua sesi selesai |

Jangan mengetik `SOURCE ...` pada tab SQL phpMyAdmin. SOURCE merupakan perintah klien CLI MariaDB; antarmuka web memakai tab Import atau isi SQL yang disalin.

### 4.3 Transaksi melalui web dan batas sesi

Untuk contoh singkat pada phpMyAdmin, kirim **seluruh blok berikut dalam satu eksekusi**. Jalankan tanpa transaksi CLI yang masih membuka kunci pada tabel ini:

```sql
START TRANSACTION;
SELECT id_rekening, saldo FROM t3_rekening WHERE id_rekening = 1;
UPDATE t3_rekening SET saldo = saldo + 1000.00 WHERE id_rekening = 1;
SELECT id_rekening, saldo FROM t3_rekening WHERE id_rekening = 1;
ROLLBACK;
SELECT id_rekening, saldo FROM t3_rekening WHERE id_rekening = 1;
```

Hasil SELECT kedua memperlihatkan kenaikan 1000.00; hasil terakhir kembali ke nilai pertama. Contoh ini merupakan perubahan yang dibatalkan, bukan transfer antarrekening.

Untuk memeriksa COMMIT pada web, kirim blok lengkap berikut dalam satu eksekusi, lalu jalankan SELECT terpisah untuk melihat nilai yang tersimpan:

```sql
START TRANSACTION;
UPDATE t3_rekening SET saldo = saldo + 1000.00 WHERE id_rekening = 1;
COMMIT;
SELECT id_rekening, saldo FROM t3_rekening WHERE id_rekening = 1;
```

Blok COMMIT ini menambah 1000.00 pada data lab. Setelah mengamati, kirim blok berikut **sekali** untuk mengembalikannya; jangan mengulang pengurangan jika blok penambahan belum berhasil:

```sql
START TRANSACTION;
UPDATE t3_rekening SET saldo = saldo - 1000.00 WHERE id_rekening = 1;
COMMIT;
```

Dua klik tab SQL atau dua tab browser tidak menjamin dua sesi database yang dapat dikendalikan. Untuk demo transfer bertahap, SAVEPOINT, dan penguncian dua sesi, gunakan CLI pada Bagian 5. Jangan mengirim START TRANSACTION pada satu permintaan web lalu berharap transaksi yang sama masih terbuka pada klik berikutnya.

## 5. CLI untuk transaksi dan dua sesi

Tetap dari folder `docker-alternatif`:

```sh
docker compose cp ../sql db-a:/tmp/tuweb03-sql
docker compose exec db-a mariadb -u mahasiswa -p tuweb02
```

Jalankan isi [03-transaksi.sql](sql/03-transaksi.sql) tahap demi tahap pada satu koneksi. Periksa jumlah baris debit/kredit sebelum COMMIT sebagaimana dijelaskan pada materi utama.

Untuk demo penguncian, buka **dua terminal**, lalu jalankan perintah `docker compose exec db-a mariadb -u mahasiswa -p tuweb02` pada masing-masing terminal. Pastikan `SELECT CONNECTION_ID();` berbeda. Ikuti [urutan dua sesi pada materi utama](TUWEB03_Basis_Data.md#82-demo-dua-koneksi-menunggu-kunci).

Perbedaannya hanya service tujuan: contoh utama memakai `db`, sedangkan paket mandiri memakai `db-a`. Tetap arahkan **kedua koneksi ke db-a** agar berkonflik pada baris yang sama. Satu koneksi ke A dan satu ke B tidak mendemokan konflik kunci pada satu server.

## 6. Opsional: dua node tanpa VirtualBox

Dari folder yang sama:

```sh
docker compose --profile dua-node up -d --wait
docker compose --profile dua-node ps
```

Kini ada dua instance MariaDB dengan volume berbeda. phpMyAdmin tetap pada http://localhost:8081; pilih **Node A** atau **Node B (profil dua-node)** saat login. Jika sudah masuk, keluar lalu pilih server lain. Keduanya memakai akun `mahasiswa` dan password dari `.env` yang sama, tetapi data disimpan terpisah.

### 6.1 Buktikan identitas dan pemisahan data

1. Pada Node A, jalankan `SELECT @@hostname AS node;`. Hasil: `tuweb03-db-a`.
2. Pada Node B, jalankan query yang sama. Hasil: `tuweb03-db-b`.
3. Pada Node A, jalankan:

```sql
UPDATE t3_pasien SET nama_pasien = 'Pasien A di Node A'
WHERE id_pasien = 1;
SELECT id_pasien, nama_pasien FROM t3_pasien WHERE id_pasien = 1;
```

4. Pindah ke Node B dan jalankan SELECT yang sama. Pada data awal B, namanya masih `Pasien A`.
5. Kembalikan nama pada Node A setelah demo:

```sql
UPDATE t3_pasien SET nama_pasien = 'Pasien A' WHERE id_pasien = 1;
```

Kedua node mendapat data awal yang sama karena membaca berkas init yang sama. Ini **dua instance independen**, belum replikasi dan belum otomatis menjadi satu basis data terdistribusi secara logis. Perubahan A tidak dikirim ke B. Konfigurasi replikasi dan akses gabungan dilanjutkan pada TUWEB 04.

### 6.2 Buktikan koneksi antarnode

Dari terminal pada folder `docker-alternatif`:

```sh
docker compose exec db-a mariadb --host=db-b --port=3306 -u mahasiswa -p tuweb02
```

Masukkan password mahasiswa. Pada prompt yang terbuka:

```sql
SELECT @@hostname AS server_tujuan, DATABASE() AS database_aktif;
SELECT COUNT(*) AS jumlah_pasien FROM t3_pasien;
```

Hasil server tujuan harus `tuweb03-db-b`, jumlah pasien awal 3. Perintah klien berjalan di container A tetapi koneksi SQL menuju B. Koneksi ini membuktikan resolusi nama, jalur TCP, dan autentikasi DB untuk contoh tersebut. Gunakan `exit;` untuk keluar.

Alamat antarservice memakai `db-b:3306`, bukan `localhost:3309`. Port 3309 untuk klien pada komputer host. IP container dapat berubah; gunakan nama service Compose. Tidak perlu menetapkan IP statis atau memasang ping pada container untuk uji SQL ini.

## 7. Mengganti demo VirtualBox dalam alokasi 90 menit

Gunakan blok menit **80-87** sebagai alternatif, dengan paket sudah disiapkan sebelum sesi:

| Menit | Aktivitas | Bukti |
| --- | --- | --- |
| 80-82 | Tunjukkan `docker compose --profile dua-node ps` dan layanan web | Dua instance DB dan satu klien web dikenali |
| 82-84 | Pilih node A/B di phpMyAdmin; jalankan SELECT hostname | Nama server berbeda |
| 84-87 | Tunjukkan perubahan lokal A dan keadaan B; jelaskan jaringan/volume | Pemisahan data dipahami; replikasi belum diaktifkan |

Jika perangkat hanya mampu satu node, tunjukkan node A, tab Structure/SQL, dan koneksi CLI ke server yang sama. Jadikan dua node kegiatan lanjutan. Alokasi total tetap **90 menit**; persiapan image dan pengunduhan tidak dimasukkan ke demo tujuh menit.

Untuk laporan alternatif, sertakan alat dan versi yang dipakai, daftar service, database aktif, query beserta hasil, serta batas simulasi satu laptop. Nyatakan bahwa jalur Docker dipakai karena VirtualBox tidak tersedia. Jangan menyebutnya bukti instalasi guest Ubuntu. Instruksi pengumpulan resmi tetap mengikuti kelas.

## 8. Hentikan, mulai kembali, dan simpan data

Perintah berikut **untuk paket mandiri dari folder docker-alternatif**:

```sh
docker compose --profile dua-node stop
```

Mulai kembali satu node dengan `docker compose up -d --wait`, atau dua node dengan `docker compose --profile dua-node up -d --wait`. Untuk menghapus container/jaringan dengan volume tetap ada:

```sh
docker compose --profile dua-node down
```

Volume tetap menyimpan data. Jangan memakai `down -v` jika hasil latihan masih diperlukan. Untuk cadangan via phpMyAdmin, pilih server dan database yang benar, lalu **Export > SQL** dan unduh berkas. Cadangkan node A/B secara terpisah jika keduanya sudah diubah.

## 9. Kendala umum

| Gejala | Pemeriksaan |
| --- | --- |
| Docker CLI tidak tersedia | Periksa instalasi Rancher Desktop, engine moby, dan buka ulang terminal |
| Port 8081/3308/3309 sudah digunakan | Ubah variabel ALT_* pada `.env`, lalu jalankan ulang Compose |
| Login ke Node B gagal | Pastikan profil `dua-node` aktif dan `db-b` healthy; jika satu node, pilih Node A |
| Password baru ditolak setelah mengubah `.env` | Akun pada volume lama tidak otomatis diperbarui; gunakan password yang berlaku atau ubah akun lewat DBMS |
| phpMyAdmin tidak menemukan server | Periksa service, jaringan Compose, dan nama `db-a`/`db-b` |
| Tabel t3_ belum ada | Periksa log init dan database; pada volume lama, impor skrip 00 setelah seluruh transaksi selesai |
| Data di port 8080 dan 8081 berbeda | Itu dua paket/server berbeda; periksa pilihan jalur dan hostname |
| Query SOURCE gagal pada web | Gunakan Import atau salin isi SQL; SOURCE hanya untuk CLI |
| Transaksi tidak bertahan antar klik | Gunakan satu blok web lengkap atau koneksi CLI yang tetap terbuka |
| Container unhealthy | Jalankan `docker compose logs --tail 100 db-a` atau `db-b` |

## 10. Rujukan dan status uji

- [phpMyAdmin: Docker environment variables](https://docs.phpmyadmin.net/en/release_5_2_2/setup.html#docker-environment-variables), terutama PMA_HOSTS, PMA_PORTS, dan PMA_VERBOSES.
- [Docker: networking in Compose](https://docs.docker.com/compose/how-tos/networking/).
- [Rancher Desktop: introduction](https://docs.rancherdesktop.io/).
- [Status pemeriksaan TUWEB 03](VERIFIKASI.md): konfigurasi dan jalur berkas diperiksa secara statis; startup container, antarmuka web, dan koneksi antarnode masih perlu diuji lokal.
