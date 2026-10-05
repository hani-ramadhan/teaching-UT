# Status pemeriksaan paket TUWEB 02

**Tanggal:** 5 Oktober 2026.

## Pemeriksaan yang dilakukan

| Pemeriksaan | Hasil |
| --- | --- |
| Alokasi waktu | Delapan blok tersambung dari menit 0 sampai 90; total 90 menit |
| Struktur Compose | YAML dapat dibaca; MariaDB 11.4, volume data, init SQL, healthcheck, dan profil GUI sesuai panduan |
| Konfigurasi contoh | `.env.example` tersedia; `.env` tidak disertakan dan diabaikan Git |
| Model data awal | Sepuluh tabel dengan 25 baris data fiktif; PK unik dan semua referensi FK mempunyai induk |
| Query faktur | Tiga detail; total F001 = 35000 dan F002 = 9000 |
| GraphML | XML dapat dibaca; 10 node dan 9 hubungan; atribut serta hubungan sesuai skema SQL |
| Markdown | Tautan berkas lokal tersedia dan blok kode berpasangan |

Pemeriksaan data dan query dilakukan pada SQLite di memori dengan adaptasi sementara: perintah `USE`, `AUTO_INCREMENT`, serta `ENGINE=InnoDB` dihapus dari salinan SQL. Berkas MariaDB yang dibagikan tetap memakai sintaks aslinya. Pemeriksaan ini memeriksa data contoh dan logika relasi/query, **bukan membuktikan kompatibilitas runtime MariaDB**.

## Yang perlu diuji pada komputer tutor

Docker dan MariaDB tidak tersedia pada lingkungan penyusunan. Impor berkas melalui antarmuka yEd Live juga belum dijalankan. Karena itu, lakukan pemeriksaan berikut sebelum kelas:

1. Salin `.env.example` ke `.env`, isi password, lalu jalankan `docker compose config --quiet`.
2. Jalankan `docker compose up -d --wait db` dan periksa `docker compose ps`.
3. Login mengikuti [LAB_DOCKER.md](LAB_DOCKER.md). Jalankan `SELECT VERSION();`, `SHOW TABLES;`, dan `SELECT COUNT(*) FROM pasien_dokter;`. Harapkan 10 tabel awal dan 4 pemeriksaan.
4. Jalankan `sql/demo/01-ddl-dml.sql` tahap demi tahap. Periksa perubahan struktur, isi data, dan hasil penghapusan.
5. Jalankan `sql/demo/02-faktur-preview.sql`. Cocokkan tiga detail serta dua total di atas.
6. Buka kedua GraphML di yEd Live. Pastikan label PK/FK, arah pembacaan induk-ke-kegiatan, dan label `1 : 0..N` terbaca. Rapikan posisi label jika editor mengubah penempatan.
7. Bila memakai GUI, jalankan profil `gui` dan uji login pengguna `mahasiswa` pada localhost:8080.

Jangan menghapus volume data untuk sekadar menguji ulang. Perintah reset dalam panduan lab menghapus isi database lokal dan hanya dipakai ketika memang diperlukan.
