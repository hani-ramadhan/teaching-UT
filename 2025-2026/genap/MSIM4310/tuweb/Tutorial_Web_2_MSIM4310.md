# MODUL TUTORIAL WEB 2
## MSIM4310 Analisis dan Visualisasi Data
### Program Studi Sistem Informasi — Universitas Terbuka

---

> **Cara Menggunakan Modul Ini**
>
> Modul ini dirancang untuk **memandu proses berpikir**, bukan memberikan jawaban langsung.
> Setiap bagian memuat: (1) ringkasan konsep, (2) kode R untuk eksplorasi & verifikasi,
> dan (3) **Cek Pemahaman** — pertanyaan yang Anda jawab sendiri berdasarkan output R.
> Tutor akan memverifikasi hasil Anda, bukan memberikan solusi siap pakai.

---

## Daftar Isi

1. [Ukuran Pemusatan & Penyebaran Data (AB1)](#ab1)
2. [Koefisien Keragaman & Z-Score](#cv)
3. [Bentuk-Bentuk Penyajian Data (AB2)](#ab2)
4. [Praktikum Dasar R (AB3)](#ab3)
5. [Transformasi Data: Konsep & Bentuk (AB5 & AB6)](#ab56)
6. [Data Hilang: Definisi, Karakteristik & Penanganan (AB7)](#ab7)
7. [How-To: Bercerita dengan Data — Prinsip & Praktik](#storytelling)
8. [BONUS: Studi Kasus Dataset Mahasiswa AVD](#bonus)

---

## 1. Ukuran Pemusatan & Penyebaran Data (AB1) {#ab1}

### Ringkasan Konsep

Ukuran **pemusatan data** menjawab pertanyaan: *"Di mana pusat data kita?"*

| Ukuran | Definisi Singkat | Fungsi R |
|---|---|---|
| **Mean** | Rata-rata aritmatik | `mean(x)` |
| **Median** | Nilai tengah data terurut | `median(x)` |
| **Modus** | Nilai yang paling sering muncul | `table(x)` atau paket `modeest` |

Ukuran **penyebaran data** menjawab: *"Seberapa tersebar data kita?"*

| Ukuran | Definisi Singkat | Fungsi R |
|---|---|---|
| **Range** | Nilai max − min | `diff(range(x))` |
| **Variansi** | Rata-rata kuadrat simpangan | `var(x)` |
| **Simpangan Baku** | Akar variansi | `sd(x)` |

> **Catatan penting:** `var()` dan `sd()` di R secara default menghitung **variansi & simpangan baku sampel** (pembagi *n−1*). Untuk populasi, Anda perlu menyesuaikan rumusnya.

### Kode R: Eksplorasi & Verifikasi

```r
# ---- Data nilai ujian mahasiswa ----
nilai <- c(72, 85, 90, 68, 77, 88, 95, 70, 82, 79,
           91, 65, 83, 74, 88, 92, 78, 69, 85, 80)

# --- Ukuran Pemusatan ---
cat("Mean   :", mean(nilai), "\n")
cat("Median :", median(nilai), "\n")

# Modus (base R tidak punya fungsi modus langsung)
tabel <- table(nilai)
cat("Modus  :", names(tabel[tabel == max(tabel)]), "\n")

# --- Ukuran Penyebaran ---
cat("\nRange  :", diff(range(nilai)))
cat("\nVariansi (sampel)    :", var(nilai))
cat("\nSimpangan Baku (sampel):", sd(nilai))

# --- Ringkasan Sekaligus ---
summary(nilai)

# --- Visualisasi Distribusi ---
par(mfrow = c(1, 2))
hist(nilai,
     main = "Distribusi Nilai Ujian",
     xlab = "Nilai", ylab = "Frekuensi",
     col = "#4E79A7", border = "white")
abline(v = mean(nilai), col = "red", lwd = 2, lty = 2)
abline(v = median(nilai), col = "darkgreen", lwd = 2, lty = 3)
legend("topleft", legend = c("Mean", "Median"),
       col = c("red", "darkgreen"), lty = c(2, 3), lwd = 2)

boxplot(nilai,
        main = "Boxplot Nilai Ujian",
        ylab = "Nilai",
        col = "#F28E2B", border = "#333333",
        horizontal = FALSE)
```

### ✅ Cek Pemahaman AB1

Jalankan kode di atas, lalu jawab sendiri:

1. Berapa nilai mean, median, dan modus dari data `nilai`?
2. Apakah mean > median, mean < median, atau keduanya hampir sama? Apa kesimpulan Anda tentang **bentuk distribusi** data tersebut?
3. Dari boxplot, apakah terdapat *outlier*? Bagaimana Anda mengetahuinya?
4. Mengapa simpangan baku lebih sering digunakan daripada variansi dalam pelaporan?
5. **Tantangan:** Ubah satu nilai menjadi `200` (misalnya, `nilai[1] <- 200`). Ukuran pemusatan mana yang paling terpengaruh — mean atau median? Mengapa?

---

## 2. Koefisien Keragaman & Z-Score {#cv}

### Ringkasan Konsep

**Koefisien Keragaman (CV)** berguna untuk *membandingkan variabilitas* dua kelompok data yang memiliki skala berbeda.

$$CV = \frac{s}{\bar{x}} \times 100\%$$

| Notasi | Dibaca | Arti |
|---|---|---|
| $CV$ | *coefficient of variation* | Koefisien keragaman; hasil dinyatakan dalam **persen** |
| $s$ | *s* (simpangan baku sampel) | Mengukur seberapa jauh nilai-nilai menyebar dari rata-rata. Dihitung sebagai $s = \sqrt{\frac{\sum(x_i - \bar{x})^2}{n-1}}$ |
| $\bar{x}$ | *x-bar* | Rata-rata (mean) sampel |

> **Mengapa dikalikan 100%?** Karena $s/\bar{x}$ menghasilkan angka desimal (misalnya 0,073). Dikalikan 100% menjadi persentase (7,3%) agar lebih mudah dibaca dan dibandingkan.

---

**Z-Score (Angka Baku)** mengkonversi nilai ke satuan standar deviasi:

$$Z = \frac{x_i - \bar{x}}{SD}$$

| Notasi | Dibaca | Arti |
|---|---|---|
| $Z$ | *z* (z-score / angka baku) | Hasil konversi: menunjukkan posisi $x_i$ dalam satuan SD relatif terhadap rata-rata |
| $x_i$ | *x sub-i* | Nilai observasi ke-$i$ yang ingin dihitung z-score-nya |
| $\bar{x}$ | *x-bar* | Rata-rata sampel (atau populasi, ditulis $\mu$) |
| $SD$ | *standard deviation* | Simpangan baku; dalam konteks sampel ditulis $s$, populasi ditulis $\sigma$ |

**Perbedaan notasi populasi vs. sampel** — perlu diperhatikan konsistensinya:

| | Populasi | Sampel |
|---|---|---|
| Rata-rata | $\mu$ (mu) | $\bar{x}$ (x-bar) |
| Simpangan baku | $\sigma$ (sigma) | $s$ |
| Variansi | $\sigma^2$ | $s^2$ |
| Ukuran data | $N$ (kapital) | $n$ (kecil) |
| Pembagi variansi | $N$ | $n - 1$ (koreksi Bessel) |

> **Koreksi Bessel ($n-1$):** Sampel cenderung meremehkan variansi populasi. Membagi dengan $n-1$ menghasilkan estimasi yang tidak bias (*unbiased*). Itulah mengapa `var()` dan `sd()` di R secara default menggunakan $n-1$.

Interpretasi Z-score: $Z > 0$ artinya di atas rata-rata; $Z < 0$ artinya di bawah rata-rata; $Z = 0$ artinya tepat sama dengan rata-rata.

> **Perhatikan kesalahan umum:** Pada Contoh 2 di modul Koefisien Keragaman, terdapat ketidakkonsistenan antara narasi ("standar deviasi 15, rata-rata 90") dan perhitungan (menggunakan SD=12, mean=100 untuk CVY). Pastikan Anda selalu menggunakan angka yang konsisten.

### Kode R: Verifikasi

```r
# ---- Fungsi CV ----
cv <- function(x) (sd(x) / mean(x)) * 100

# ---- Dataset dua kelas ----
kelas_A <- c(78, 82, 85, 79, 88, 91, 77, 83, 80, 86)
kelas_B <- c(55, 70, 90, 45, 95, 60, 88, 72, 50, 85)

cat("=== Kelas A ===\n")
cat("Mean:", mean(kelas_A), "| SD:", round(sd(kelas_A), 2),
    "| CV:", round(cv(kelas_A), 2), "%\n")

cat("\n=== Kelas B ===\n")
cat("Mean:", mean(kelas_B), "| SD:", round(sd(kelas_B), 2),
    "| CV:", round(cv(kelas_B), 2), "%\n")

cat("\nKelas mana yang lebih 'seragam'? Kelas ... dengan CV lebih ...",
    ifelse(cv(kelas_A) < cv(kelas_B), "A dengan CV lebih kecil", "B dengan CV lebih kecil"), "\n")

# ---- Z-Score ----
# Kasus: Membandingkan performa pada dua ujian berbeda
skor_mat  <- 82; mean_mat <- 75; sd_mat <- 8
skor_stat <- 78; mean_stat <- 70; sd_stat <- 5

z_mat  <- (skor_mat  - mean_mat)  / sd_mat
z_stat <- (skor_stat - mean_stat) / sd_stat

cat("\n=== Z-Score ===\n")
cat("Z Matematika:", round(z_mat, 3), "\n")
cat("Z Statistik :", round(z_stat, 3), "\n")
cat("Performa lebih baik di:",
    ifelse(z_mat > z_stat, "Matematika", "Statistik"), "\n")
```

### ✅ Cek Pemahaman CV & Z-Score

1. Antara Kelas A dan B, kelas mana yang nilai ujiannya lebih seragam? Jelaskan berdasarkan CV.
2. Jika rata-rata Kelas A dan B hampir sama, tetapi CV mereka berbeda jauh, apa yang bisa disimpulkan?
3. Seseorang mendapat nilai 80 di dua ujian berbeda. Apakah performa mereka pasti *sama baik*? Gunakan konsep Z-score untuk menjelaskan.
4. **Tantangan:** Hitung CV untuk data `nilai` dari AB1. Interpretasikan hasilnya: apakah data tersebut "seragam" atau "beragam"?

---

## 3. Bentuk-Bentuk Penyajian Data (AB2) {#ab2}

### Ringkasan Konsep

Penyajian data yang baik adalah yang **tepat guna** — sesuai jenis data dan pesan yang ingin disampaikan.

| Jenis Grafik | Terbaik Untuk | Hindari Saat |
|---|---|---|
| Bar Chart | Membandingkan kategori | Terlalu banyak kategori (> 10) |
| Pie Chart | Proporsi (maks. ~5 slice) | Nilai antar slice sangat mirip |
| Line Chart | Tren waktu / data kontinu | Data kategorik tidak berurutan |
| Histogram | Distribusi data numerik | Data kategorik |
| Boxplot | Perbandingan distribusi antar kelompok | Sampel sangat kecil (< 5) |
| Scatter Plot | Hubungan dua variabel numerik | Mencari proporsi/tren waktu |
| Heatmap | Pola dalam matriks besar | Data sederhana |

### Kode R: Galeri Visualisasi Dasar

```r
# Install dan muat ggplot2 jika belum ada
# install.packages("ggplot2")
library(ggplot2)

# ---- Data contoh: Penjualan per Departemen ----
dept_data <- data.frame(
  departemen = c("SDM", "IT", "Keuangan", "Pemasaran", "Operasional"),
  penjualan  = c(120, 200, 150, 180, 90),
  kuartal    = rep("Q1 2024", 5)
)

# --- Bar Chart ---
ggplot(dept_data, aes(x = reorder(departemen, -penjualan), y = penjualan)) +
  geom_bar(stat = "identity", fill = "#4E79A7") +
  geom_text(aes(label = penjualan), vjust = -0.5, size = 4) +
  labs(title = "Penjualan per Departemen — Q1 2024",
       x = "Departemen", y = "Penjualan (juta Rp)") +
  theme_minimal()

# --- Pie Chart ---
ggplot(dept_data, aes(x = "", y = penjualan, fill = departemen)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(title = "Proporsi Penjualan per Departemen") +
  theme_void() +
  theme(legend.position = "right")

# --- Line Chart: Tren Bulanan ---
tren_data <- data.frame(
  bulan  = month.abb[1:6],
  nilai  = c(150, 160, 145, 175, 190, 185)
)
tren_data$bulan <- factor(tren_data$bulan, levels = month.abb[1:6])

ggplot(tren_data, aes(x = bulan, y = nilai, group = 1)) +
  geom_line(color = "#E15759", linewidth = 1.2) +
  geom_point(color = "#E15759", size = 3) +
  labs(title = "Tren Penjualan Jan–Jun 2024",
       x = "Bulan", y = "Penjualan (juta Rp)") +
  theme_minimal()
```

### ✅ Cek Pemahaman AB2

1. Kapan Anda sebaiknya menggunakan histogram daripada bar chart? Apa perbedaan mendasarnya?
2. Pie chart sering dikritik oleh ahli visualisasi. Menurut Anda, apa kelemahannya dibanding bar chart horizontal?
3. Data tren penjualan selama 3 tahun terakhir — visualisasi apa yang paling tepat? Jelaskan.
4. **Coba ubah kode bar chart:** Bagaimana hasilnya jika Anda menghapus `reorder(departemen, -penjualan)` dan menggunakan `departemen` saja? Mana tampilan yang lebih informatif?

---

## 4. Praktikum Dasar R (AB3) {#ab3}

### Ringkasan Konsep

Praktikum ini memperkenalkan R sebagai "kalkulator statistik" dan lingkungan pemrograman dasar.

**Konsep kunci yang harus dikuasai:**

- Vektor, data frame, dan operasi dasarnya
- Fungsi `sd()`, `mean()`, `var()`, `summary()`
- Fungsi `plot()`: parameter `main`, `xlab`, `ylab`, `col`, `cex`, `pch`, `type`
- Operator `$` untuk mengakses kolom data frame

### Kode R: Ekspansi Praktikum AB3

```r
# ---- Verifikasi Contoh 3 (AB3) ----
data <- c(2, 3, 5, 6, 10, 13, 18, 22, 24, 25)
cat("Standar deviasi data:", round(sd(data), 4), "\n")
# Tuliskan hasilnya. Apakah sesuai perhitungan manual Anda?

# ---- Verifikasi Contoh 4 (AB3) ----
data_frame_1 <- data.frame(
  data_1 = c(1, 3, 4, 6, 8, 9),
  data_2 = c(7, 8, 8, 7, 13, 16),
  data_3 = c(11, 13, 13, 18, 19, 22),
  data_4 = c(12, 16, 18, 22, 29, 38)
)

cat("\nSD data_1:", round(sd(data_frame_1$data_1), 4))
cat("\nSD data_2:", round(sd(data_frame_1$data_2), 4))
cat("\nSD data_3:", round(sd(data_frame_1$data_3), 4))
cat("\nSD data_4:", round(sd(data_frame_1$data_4), 4))

# ---- Eksplorasi plot() lebih lanjut ----
# Coba berbagai nilai pch dan perhatikan bentuk titiknya
par(mfrow = c(2, 3))
for (p in c(1, 3, 6, 15, 17, 19)) {
  plot(1:10, main = paste("pch =", p),
       pch = p, col = "steelblue", cex = 1.5,
       xlab = "", ylab = "")
}
par(mfrow = c(1, 1))

# ---- Latihan Mandiri: Grafik Bertumpuk ----
x <- 1:20
y1 <- x^1.5
y2 <- log(x) * 10

plot(x, y1, type = "l", col = "blue", lwd = 2,
     main = "Perbandingan Dua Fungsi",
     xlab = "x", ylab = "y", ylim = c(0, 100))
lines(x, y2, col = "red", lwd = 2, lty = 2)
legend("topleft", legend = c("x^1.5", "10*log(x)"),
       col = c("blue", "red"), lty = c(1, 2), lwd = 2)
```

### ✅ Cek Pemahaman AB3

1. Berapa hasil `sd(data)` untuk data Contoh 3? Cek apakah jawaban Anda sesuai dengan yang dihitung R.
2. Dari empat kolom di `data_frame_1`, kolom mana yang memiliki simpangan baku terbesar? Apa artinya secara statistik?
3. Apa perbedaan antara `type = "l"` dan `type = "p"` dalam fungsi `plot()`?
4. **Tantangan:** Buat grafik dengan dua garis menggunakan `plot()` dan `lines()`, lalu tambahkan judul, label sumbu, dan legenda.

---

## 5. Transformasi Data: Konsep & Bentuk (AB5 & AB6) {#ab56}

### Ringkasan Konsep

Transformasi data dilakukan ketika data **tidak memenuhi asumsi** analisis yang akan digunakan.

```
Kapan perlu transformasi?
┌─────────────────────────────────────────────────┐
│  Data sangat skewed (miring)  → Log / Akar kuadrat
│  Variansi tidak konstan       → Log / Box-Cox
│  Hubungan tidak linear        → Log / Pangkat
│  Skala berbeda antar fitur    → Normalisasi / Standarisasi
│  Data kategorik               → Encoding
└─────────────────────────────────────────────────┘
```

**Transformasi Tukey (Ladder of Powers):**

| Pangkat (λ) | Transformasi | Cocok untuk |
|---|---|---|
| 2 | x² | Skewness negatif kuat |
| 1 | x | Tidak perlu transformasi |
| 0.5 | √x | Skewness positif ringan |
| 0 | log(x) | Skewness positif sedang |
| −0.5 | 1/√x | Skewness positif kuat |
| −1 | 1/x | Skewness positif sangat kuat |

**Menguji normalitas di R:**

- Visual: Histogram + kurva normal, Q-Q plot
- Statistik: `shapiro.test()` (Shapiro-Wilk, efektif untuk n < 50)

### Kode R: Transformasi & Uji Normalitas

```r
set.seed(42)

# ---- Data skewed positif (simulasi pendapatan) ----
pendapatan <- c(25, 30, 35, 40, 100, 200, 300, 400, 500, 1000,
                28, 33, 38, 45, 120, 250, 350, 480, 550, 950)

# ---- Transformasi ----
pd_log    <- log(pendapatan)         # log natural
pd_log10  <- log10(pendapatan)       # log basis 10
pd_sqrt   <- sqrt(pendapatan)        # akar kuadrat
pd_sq     <- pendapatan^2            # kuadrat (untuk skewness negatif)

# ---- Visualisasi sebelum & sesudah ----
par(mfrow = c(2, 3))

hist(pendapatan, main = "Data Asli", col = "#4E79A7", border = "white",
     xlab = "Pendapatan (ribu Rp)")
hist(pd_log,    main = "Transformasi Log Natural", col = "#59A14F",
     border = "white", xlab = "ln(Pendapatan)")
hist(pd_log10,  main = "Transformasi Log10", col = "#F28E2B",
     border = "white", xlab = "log10(Pendapatan)")
hist(pd_sqrt,   main = "Transformasi Akar Kuadrat", col = "#E15759",
     border = "white", xlab = "√Pendapatan")

# Q-Q Plot data asli vs log-transformasi
qqnorm(pendapatan, main = "Q-Q Plot: Data Asli", pch = 16, col = "#4E79A7")
qqline(pendapatan, col = "red", lwd = 2)

qqnorm(pd_log, main = "Q-Q Plot: Log Natural", pch = 16, col = "#59A14F")
qqline(pd_log, col = "red", lwd = 2)

par(mfrow = c(1, 1))

# ---- Uji Shapiro-Wilk ----
cat("=== Uji Normalitas Shapiro-Wilk ===\n")
cat("Data asli   : p-value =", round(shapiro.test(pendapatan)$p.value, 4), "\n")
cat("Log natural : p-value =", round(shapiro.test(pd_log)$p.value, 4), "\n")
cat("Log10       : p-value =", round(shapiro.test(pd_log10)$p.value, 4), "\n")
cat("Akar kuadrat: p-value =", round(shapiro.test(pd_sqrt)$p.value, 4), "\n")

# ---- Normalisasi vs Standarisasi ----
# Normalisasi Min-Max → rentang [0, 1]
normalisasi <- function(x) (x - min(x)) / (max(x) - min(x))

# Standarisasi Z-score → mean=0, sd=1
standarisasi <- function(x) (x - mean(x)) / sd(x)

cat("\n=== Perbandingan Normalisasi vs Standarisasi ===\n")
cat("Nilai asli (3 pertama):", head(pendapatan, 3), "\n")
cat("Normalisasi           :", round(head(normalisasi(pendapatan), 3), 4), "\n")
cat("Standarisasi          :", round(head(standarisasi(pendapatan), 3), 4), "\n")
```

### ✅ Cek Pemahaman AB5 & AB6

1. Berapa p-value Shapiro-Wilk untuk data asli vs. log-transformasi? Transformasi mana yang **paling berhasil** mendekati normalitas?
2. Pada Q-Q plot, bagaimana Anda mengenali bahwa data berdistribusi normal? Jelaskan secara visual.
3. Apa perbedaan praktis antara **normalisasi** dan **standarisasi**? Kapan Anda memilih normalisasi, dan kapan memilih standarisasi?
4. Data berikut memiliki skewness negatif: `c(50, 60, 70, 75, 80, 82, 83, 85, 87, 90)`. Transformasi apa yang paling sesuai menurut Tukey's Ladder?
5. **Tantangan:** Hitung **skewness** sebelum dan sesudah transformasi menggunakan `library(e1071); skewness(x)`. Apakah skewness mendekati 0 setelah transformasi?

---

## 6. Data Hilang: Definisi, Karakteristik & Penanganan (AB7) {#ab7}

### Ringkasan Konsep

**Tiga tipe data hilang** yang perlu Anda bedakan:

```
MCAR  → Hilang sepenuhnya acak. Tidak ada pola.
        Penanganan: relatif aman; listwise deletion bisa digunakan.

MAR   → Hilang bergantung pada variabel lain yang TERSEDIA.
        Penanganan: imputasi berdasarkan variabel lain.

MNAR  → Hilang bergantung pada nilai itu sendiri (tidak teramati).
        Penanganan: paling sulit; perlu pertimbangan domain.
```

> **Penting untuk diingat:** Menghapus baris dengan `na.omit()` hanya aman jika data hilang berjumlah sedikit dan pola hilangnya adalah MCAR. Imputasi selalu lebih diutamakan.

### Kode R: Deteksi & Penanganan Data Hilang

```r
# install.packages(c("VIM", "mice"))
library(VIM)
library(mice)

# ---- Data contoh dengan NA ----
set.seed(123)
data_survei <- data.frame(
  id        = 1:20,
  usia      = c(25, 30, NA, 40, 35, 50, NA, 45, 55, 60,
                28, NA, 38, 42, 33, 48, 52, 44, 58, 37),
  pendidikan = c("S1","SMA","S1",NA,"S2","SMA","S1","S2",NA,"S1",
                 "SMA","S1","S2","SMA",NA,"S1","S2","SMA","S1","S2"),
  pendapatan = c(50, 60, 55, NA, 70, 65, 75, 80, NA, 90,
                 45, 55, NA, 70, 60, 72, 85, 68, NA, 88)
)

# ---- 1. Deteksi Data Hilang ----
cat("=== Jumlah NA per Kolom ===\n")
print(colSums(is.na(data_survei)))

cat("\nTotal NA:", sum(is.na(data_survei)), "\n")
cat("Persentase NA:", round(mean(is.na(data_survei)) * 100, 2), "%\n")

# Visualisasi pola data hilang
aggr(data_survei,
     col = c("#4E79A7", "#E15759"),
     numbers = TRUE, sortVars = TRUE,
     labels = names(data_survei),
     cex.axis = 0.8, gap = 3,
     ylab = c("Proporsi NA", "Pola NA"))

# ---- 2. Imputasi Sederhana ----
data_imp_mean <- data_survei
data_imp_mean$usia[is.na(data_imp_mean$usia)] <-
  mean(data_survei$usia, na.rm = TRUE)
data_imp_mean$pendapatan[is.na(data_imp_mean$pendapatan)] <-
  median(data_survei$pendapatan, na.rm = TRUE)

cat("\n=== Setelah Imputasi Mean/Median ===\n")
cat("NA tersisa:", sum(is.na(data_imp_mean[, c("usia", "pendapatan")])), "\n")

# ---- 3. Imputasi Berganda (MICE) ----
# Hanya kolom numerik dulu untuk demonstrasi
data_num <- data_survei[, c("usia", "pendapatan")]

imputed  <- mice(data_num, m = 5, maxit = 50, method = "pmm", seed = 42,
                 printFlag = FALSE)
data_completed <- complete(imputed, 1)

cat("\n=== Hasil Imputasi MICE (dataset pertama) ===\n")
cat("NA tersisa:", sum(is.na(data_completed)), "\n")
print(head(data_completed))

# ---- 4. Perbandingan distribusi sebelum & sesudah imputasi ----
par(mfrow = c(1, 2))
hist(data_survei$usia, main = "Usia: Sebelum Imputasi",
     col = "#4E79A7", border = "white", na.rm = TRUE)
hist(data_completed$usia, main = "Usia: Setelah MICE",
     col = "#59A14F", border = "white")
par(mfrow = c(1, 1))
```

### ✅ Cek Pemahaman AB7

1. Dari output `colSums(is.na(...))`, variabel mana yang paling banyak nilai hilangnya?
2. Mengapa imputasi dengan **mean** bisa berbahaya untuk data yang sangat skewed?
3. Jelaskan perbedaan antara imputasi sederhana (mean/median) dan imputasi berganda (MICE) dalam satu paragraf singkat.
4. Jika seseorang berpendapatan sangat tinggi cenderung *tidak* mengisi kolom pendapatan, tipe data hilang apa yang terjadi — MCAR, MAR, atau MNAR?
5. **Tantangan:** Setelah imputasi, bandingkan mean dan SD kolom `usia` sebelum vs. sesudah. Apakah distribusi berubah signifikan?

---

## 7. How-To: Bercerita dengan Data — Prinsip & Praktik {#storytelling}

### Mengapa Storytelling Itu Penting?

> *"Keberhasilan seorang data scientist bukan karena kemampuan coding-nya. Keberhasilan ditentukan oleh seberapa baik ia meyakinkan pengambil keputusan untuk bertindak."*
> — Business Science (2023)

Visualisasi data tanpa narasi hanyalah kumpulan angka dan garis. **Data storytelling** adalah seni mengubah angka menjadi pesan yang menggugah tindakan.

### Tiga Prinsip Utama (Adaptasi dari John Burn-Murdoch, Financial Times)

**Prinsip 1: Gunakan Teks Sebagai Senjata Utama**

Teks bukan sekedar judul. `annotate()` di ggplot2 memungkinkan Anda menempelkan penjelasan langsung di dalam grafik, tepat di titik yang ingin Anda sorot.

> ⚠️ **Peringatan: Jaga tipe data kolom `bulan`**
>
> Jika sebelumnya Anda menjalankan kode Line Chart di AB2, kolom `bulan` di objek `tren_data`
> bertipe **factor** (karakter). Objek `tren` di bawah ini berbeda dan harus tetap bertipe
> **integer** (`1:12`). Jangan menimpa `tren$bulan` dengan `factor(...)` — itulah penyebab
> error `Discrete values supplied to continuous scale`.
>
> Jika ragu, cek dulu dengan `class(tren$bulan)`. Seharusnya hasilnya `"integer"`.
> Jika sudah berubah menjadi `"factor"`, reset dengan menjalankan ulang blok pembuatan data di bawah.

Kita membangun **dua versi grafik** dari data yang sama — ini adalah cara terbaik untuk
menunjukkan *nilai tambah* storytelling kepada mahasiswa: visualisasi yang identik secara
data, tetapi sangat berbeda dalam kemampuannya menyampaikan pesan.

```r
library(ggplot2)

# ---- Data dasar: bulan sebagai INTEGER 1:12, JANGAN diubah ----
tren <- data.frame(
  bulan = 1:12,
  nilai = c(100, 105, 98, 110, 120, 115, 130, 145, 140, 160, 175, 190)
)

# Verifikasi tipe data sebelum lanjut:
# class(tren$bulan)  # harus: "integer"

# ===========================================================
# PLOT 1 — Versi sederhana (seperti di AB2, tanpa anotasi)
# Label bulan ditampilkan via scale_x_continuous + labels
# BUKAN dengan mengubah tren$bulan menjadi factor
# ===========================================================
ggplot(tren, aes(x = bulan, y = nilai)) +
  geom_line(color = "#E15759", linewidth = 1.2) +
  geom_point(color = "#E15759", size = 3) +
  scale_x_continuous(
    breaks = 1:12,
    labels = month.abb        # tampilkan Jan–Dec, tapi sumbu tetap numerik
  ) +
  labs(
    title = "Tren Penjualan Jan–Des 2024",
    x = "Bulan", y = "Penjualan (juta Rp)"
  ) +
  theme_minimal()

# ===========================================================
# PLOT 2 — Versi storytelling (dengan anotasi peristiwa)
# Jalankan setelah Plot 1; pastikan tren$bulan masih integer
# ===========================================================
ggplot(tren, aes(x = bulan, y = nilai)) +
  geom_line(color = "#4E79A7", linewidth = 1.5) +
  geom_point(color = "#4E79A7", size = 2.5) +

  # Anotasi: garis & label peristiwa penting
  geom_vline(xintercept = 7, linetype = "dashed",
             color = "#E15759", alpha = 0.7) +
  annotate("text", x = 7.3, y = 105,
           label = "Kampanye\nPemasaran\nDimulai",
           hjust = 0, size = 3.2, color = "#E15759") +

  # Anotasi: kotak sorot periode akselerasi
  annotate("rect", xmin = 10, xmax = 12,
           ymin = 155, ymax = 195,
           alpha = 0.1, fill = "#59A14F") +
  annotate("text", x = 11, y = 197,
           label = "Pertumbuhan\nAkseleratif",
           size = 3.2, color = "#59A14F") +

  # Judul yang bercerita — bukan sekadar label
  labs(
    title    = "Kampanye Juli Mendorong Pertumbuhan Penjualan 90%",
    subtitle = "Dari 100 juta (Jan) menjadi 190 juta (Des) — lonjakan terbesar pasca-kampanye",
    caption  = "Catatan: Satuan dalam juta Rupiah | Data: Simulasi 2024",
    x = "Bulan", y = "Penjualan (juta Rp)"
  ) +
  scale_x_continuous(
    breaks = 1:12,
    labels = month.abb        # sama seperti Plot 1: numerik dengan label teks
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "gray40", size = 10),
    plot.caption  = element_text(color = "gray60", size = 8)
  )
```

> 💡 **Bandingkan Plot 1 dan Plot 2.** Data yang divisualisasikan persis sama.
> Apa yang membuat Plot 2 lebih informatif? Catat perbedaannya sebelum melanjutkan ke Prinsip 2.

**Prinsip 2: Kenali Audiens Anda**

Visualisasi yang sama dapat menyampaikan pesan berbeda tergantung kepada siapa Anda berbicara:

| Audiens | Yang Mereka Butuhkan | Pendekatan Visualisasi |
|---|---|---|
| **Eksekutif / Manajemen** | Kesimpulan cepat, implikasi bisnis | Satu grafik kunci + judul yang bercerita |
| **Analis / Rekan Kerja** | Detail teknis, metodologi | Grafik lengkap + kode + statistik deskriptif |
| **Publik Umum** | Konteks, relevansi personal | Infografik, perbandingan familiar |
| **Mahasiswa / Akademisi** | Ketelitian, reproducibility | Kode lengkap + referensi + interpretasi |

**Prinsip 3: Pilih Grafik Berdasarkan Pesan, Bukan Kebiasaan**

```
Pertanyaan panduan sebelum memilih grafik:
┌──────────────────────────────────────────────────────────┐
│ "Apakah saya sedang MEMBANDINGKAN?"   → Bar chart        │
│ "Apakah saya melihat TREN WAKTU?"     → Line chart       │
│ "Apakah saya melihat HUBUNGAN?"       → Scatter plot     │
│ "Apakah saya melihat DISTRIBUSI?"     → Histogram/Boxplot│
│ "Apakah saya melihat PROPORSI?"       → Bar/Pie (<5 slice)│
│ "Apakah ada POLA dalam MATRIKS?"      → Heatmap          │
└──────────────────────────────────────────────────────────┘
```

### Framework Bercerita dengan Data (5-Langkah)

```
Langkah 1: KONTEKS
  → Siapa audiensnya? Apa keputusan yang perlu mereka ambil?

Langkah 2: PERTANYAAN
  → "Data ini menjawab pertanyaan APA?"

Langkah 3: DATA
  → Bersihkan, transformasi jika perlu; tangani nilai hilang.

Langkah 4: VISUALISASI
  → Pilih grafik yang tepat; tambahkan teks, anotasi, highlight.

Langkah 5: NARASI
  → Satu kalimat utama: "Data ini menunjukkan bahwa..."
    Lanjutkan dengan implikasi dan rekomendasi.
```

### Kode R: Grafik Storytelling Lengkap

```r
library(ggplot2)

# ---- Dataset: Nilai rata-rata per tutorial ----
progress <- data.frame(
  tutorial    = paste("TW", 1:8),
  rata_rata   = c(72, 75, 78, 74, 80, 83, 85, 88),
  target      = rep(80, 8)
)

ggplot(progress, aes(x = tutorial, y = rata_rata, group = 1)) +
  # Area di bawah garis
  geom_ribbon(aes(ymin = 60, ymax = rata_rata),
              fill = "#4E79A7", alpha = 0.15) +
  # Garis target
  geom_hline(yintercept = 80, linetype = "dashed",
             color = "#E15759", linewidth = 0.8) +
  # Garis nilai rata-rata
  geom_line(color = "#4E79A7", linewidth = 1.5) +
  geom_point(aes(color = rata_rata >= 80), size = 3.5) +
  scale_color_manual(values = c("FALSE" = "#E15759", "TRUE" = "#59A14F"),
                     guide = "none") +
  # Anotasi target
  annotate("text", x = 8.3, y = 80.5,
           label = "Target\n80", size = 3, color = "#E15759", hjust = 0) +
  # Label nilai
  geom_text(aes(label = rata_rata), vjust = -0.9, size = 3, color = "#333333") +

  labs(
    title    = "Nilai Rata-Rata Melampaui Target Mulai Tutorial ke-5",
    subtitle = "Mahasiswa konsisten meningkat; 4 tutorial terakhir di atas target 80",
    caption  = "• Titik merah = di bawah target | Titik hijau = di atas target",
    x = "Tutorial", y = "Nilai Rata-Rata"
  ) +
  scale_y_continuous(limits = c(60, 95)) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    plot.subtitle = element_text(color = "gray40"),
    plot.caption  = element_text(color = "gray55", hjust = 0)
  )
```

### ✅ Cek Pemahaman Storytelling

1. Lihat grafik yang Anda buat. Apakah judul grafik Anda **mendeskripsikan data** atau **menyampaikan pesan**? Apa bedanya?
2. Bayangkan Anda menyajikan data nilai mahasiswa kepada: (a) Ketua Program Studi, (b) mahasiswa itu sendiri. Apakah visualisasi dan narasi Anda akan berbeda? Jelaskan.
3. **Refleksi:** Dari materi AB1–AB7 yang sudah Anda pelajari, ambil satu konsep yang menurut Anda paling penting. Buat *satu kalimat* yang bercerita tentang konsep itu kepada orang awam.

---

## BONUS: Studi Kasus — Dataset Mahasiswa AVD {#bonus}

### Latar Belakang Cerita

Anda adalah analis data di Program Studi Sistem Informasi, Universitas Terbuka. Ketua Program Studi meminta Anda menganalisis performa mahasiswa MSIM4310 selama satu semester dan **menyajikan temuan** kepada tim pengajar.

Dataset ini mencakup 50 mahasiswa fiktif dengan variabel: nilai tugas, nilai UTS, nilai UAS, kehadiran tutorial, dan wilayah asal.

### Dataset Dummy

```r
# ---- Buat dan simpan dataset ----
set.seed(2024)
n <- 50

mahasiswa_avd <- data.frame(
  id_mahasiswa = paste0("SI", sprintf("%03d", 1:n)),
  wilayah      = sample(c("Jawa", "Sumatera", "Kalimantan",
                           "Sulawesi", "Lainnya"),
                        n, replace = TRUE,
                        prob = c(0.4, 0.25, 0.15, 0.12, 0.08)),
  hadir_tutorial = sample(3:8, n, replace = TRUE),
  nilai_tugas    = round(rnorm(n, mean = 78, sd = 10)),
  nilai_uts      = round(rnorm(n, mean = 72, sd = 12)),
  nilai_uas      = round(rnorm(n, mean = 75, sd = 11))
)

# Clip nilai ke rentang 0-100
mahasiswa_avd[, 4:6] <- lapply(
  mahasiswa_avd[, 4:6],
  function(x) pmin(pmax(x, 40), 100)
)

# Tambahkan beberapa nilai hilang (simulasi MCAR)
set.seed(7)
na_idx <- sample(1:n, 5)
mahasiswa_avd$nilai_uts[na_idx] <- NA

# Hitung nilai akhir (bobot: tugas 30%, UTS 30%, UAS 40%)
mahasiswa_avd$nilai_akhir <- with(mahasiswa_avd,
  round(0.30 * nilai_tugas + 0.30 * nilai_uts + 0.40 * nilai_uas, 1)
)

# Kategorisasi nilai akhir
mahasiswa_avd$kategori <- cut(
  mahasiswa_avd$nilai_akhir,
  breaks = c(0, 55, 65, 75, 85, 100),
  labels = c("E", "D", "C", "B", "A"),
  right  = TRUE
)

head(mahasiswa_avd, 10)
```

### Tantangan Storytelling (Eksplorasi Mandiri)

Gunakan dataset `mahasiswa_avd` untuk menjawab dan memvisualisasikan setiap pertanyaan berikut. Untuk setiap visualisasi, **tuliskan satu kalimat narasi** yang merangkum temuan utama.

---

**Tantangan 1 — Distribusi & Pemusatan**
```r
# Eksplorasi distribusi nilai akhir
# Hint: Gunakan histogram + garis mean/median
# Pertanyaan: Apakah distribusi mendekati normal?
#             Di mana letak mean vs median?
summary(mahasiswa_avd$nilai_akhir)
shapiro.test(na.omit(mahasiswa_avd$nilai_akhir))
```

---

**Tantangan 2 — Perbandingan Antar Wilayah**
```r
library(ggplot2)
# Bandingkan nilai akhir berdasarkan wilayah
# Hint: Boxplot per wilayah
# Pertanyaan: Apakah ada wilayah yang performa mahasiswanya
#             berbeda signifikan?

# Mulai dari sini:
ggplot(na.omit(mahasiswa_avd),
       aes(x = reorder(wilayah, nilai_akhir, FUN = median),
           y = nilai_akhir)) +
  # Lengkapi sendiri...
  labs(title = "???")   # Ganti ??? dengan judul yang bercerita
```

---

**Tantangan 3 — Hubungan Kehadiran & Nilai**
```r
# Apakah lebih banyak hadir tutorial → nilai lebih tinggi?
# Hint: Scatter plot + garis tren

ggplot(na.omit(mahasiswa_avd),
       aes(x = hadir_tutorial, y = nilai_akhir)) +
  geom_point(aes(color = kategori), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "gray30") +
  # Tambahkan anotasi dan judul yang bercerita...
  labs(title = "???")
```

---

**Tantangan 4 — Data Hilang & Dampaknya**
```r
# Identifikasi: di nilai_uts ada 5 NA.
# Pertanyaan:
# (a) Berapa % data hilang di nilai_uts?
# (b) Gunakan imputasi mean, lalu hitung kembali nilai_akhir.
# (c) Apakah rata-rata nilai_akhir berubah signifikan?

cat("% NA nilai_uts:", mean(is.na(mahasiswa_avd$nilai_uts)) * 100, "%\n")

# Imputasi dan hitung ulang:
mahasiswa_imp <- mahasiswa_avd
mahasiswa_imp$nilai_uts[is.na(mahasiswa_imp$nilai_uts)] <-
  mean(mahasiswa_avd$nilai_uts, na.rm = TRUE)

# Bandingkan nilai_akhir sebelum vs sesudah
# (hati-hati: sebelumnya ada NA dalam perhitungan!)
```

---

**Tantangan 5 — Transformasi untuk Normalitas**
```r
# Nilai UTS memiliki beberapa karakteristik distribusi.
# Cek: apakah nilai_uts (setelah imputasi) normal?
# Jika tidak, transformasi apa yang tepat?

shapiro.test(na.omit(mahasiswa_avd$nilai_uts))

# Coba transformasi dan bandingkan hasil Shapiro-Wilk:
# - sqrt(nilai_uts)
# - log(nilai_uts)
# - nilai_uts^2
```

---

**Tantangan 6 (ADVANCED) — Dashboard Narasi Lengkap**

Buat **satu halaman ringkasan** menggunakan layout `par(mfrow)` atau paket `patchwork` yang mencakup:
1. Distribusi nilai akhir (histogram + garis mean)
2. Boxplot per wilayah
3. Scatter plot kehadiran vs. nilai
4. Tabel proporsi kategori (A/B/C/D/E)

Tambahkan **judul utama** halaman yang berfungsi sebagai "headline berita":
*"Mahasiswa MSIM4310: [temuan utama Anda dalam satu kalimat]"*

```r
# install.packages("patchwork")
library(patchwork)

# Contoh struktur:
# p1 <- ggplot(...) + ...
# p2 <- ggplot(...) + ...
# p3 <- ggplot(...) + ...
# (p1 | p2) / p3 +
#   plot_annotation(title = "Headline Narasi Anda",
#                   theme = theme(plot.title = element_text(size = 14, face = "bold")))
```

---

## Referensi & Bacaan Lanjutan

**Visualisasi & Storytelling:**
- Anderson, D. (2021). *Storytelling With Your Graphs In R Using ggplot2*. Policy in Numbers. <https://policyinnumbers.com/blog/2021/02/10/storytelling-with-your-graphs-in-r-using-ggplot2/>
- Business Science (2023). *How to improve your storytelling with R*. R-bloggers. <https://www.r-bloggers.com/2023/06/how-to-improve-your-storytelling-with-r/>
- Nussbaumer Knaflic, C. (2015). *Storytelling with Data*. Wiley.

**Dokumentasi R:**
- `?shapiro.test` — Uji normalitas Shapiro-Wilk
- `?mice` — Multiple imputation (`mice` package)
- `?ggplot2` — Sistem visualisasi `ggplot2`
- `?VIM` — Visualisasi data hilang

**Paket R yang Digunakan dalam Modul Ini:**
```r
install.packages(c("ggplot2", "VIM", "mice", "e1071", "patchwork"))
```

---

*Modul Tutorial Web 2 — MSIM4310 Analisis dan Visualisasi Data*
*Program Studi Sistem Informasi, Fakultas Sains dan Teknologi, Universitas Terbuka*
*Versi: Mei 2026*
