# MODUL TUTORIAL WEB 3
## MSIM4310 Analisis dan Visualisasi Data
### Program Studi Sistem Informasi — Universitas Terbuka

---

> **Alokasi Waktu Tutorial (60 menit)**
>
> | Sesi | Topik | Durasi |
> |---|---|---|
> | 1 | Teknik Penanganan Data Hilang (AB7 & AB8) | 10 menit |
> | 2 | Analisis Regresi: Eksplorasi & Konfirmasi (AB9 & AB10) | 40 menit |
> | 3 | Buffer & Tanya Jawab | 10 menit |
>
> **Cara menggunakan modul ini:** Setiap bagian memuat ringkasan konsep, kode R siap
> jalankan, dan **Cek Pemahaman** — pertanyaan yang Anda jawab sendiri dari output R.
> Tutor memverifikasi hasil, bukan memberikan jawaban.

---

## Daftar Isi

1. [Sesi 1 — Teknik Penanganan Data Hilang (AB7 & AB8)](#sesi1)
2. [Sesi 2 — Analisis Regresi Cara Eksplorasi (AB9)](#sesi2)
3. [Sesi 3 — Analisis Regresi Cara Konfirmasi (AB10)](#sesi3)
4. [Latihan Terpadu: Dataset Mahasiswa AVD (lanjutan)](#latihan)
5. [Referensi](#referensi)

---

## Sesi 1 — Teknik Penanganan Data Hilang (AB7 & AB8) {#sesi1}
### ⏱ 10 menit

### Ringkasan Konsep

Dari AB7, kita sudah mengenal **tiga tipe data hilang**:

```
MCAR → Hilang sepenuhnya acak. Listwise deletion relatif aman.
MAR  → Hilang bergantung variabel lain yang tersedia. Imputasi diperlukan.
MNAR → Hilang bergantung nilai itu sendiri. Penanganan paling kompleks.
```

AB8 memperluas ini dengan **menu lengkap teknik penanganan** di R:

| Teknik | Fungsi R | Cocok Untuk | Catatan |
|---|---|---|---|
| Hapus baris | `na.omit()` | MCAR, NA sedikit (< 5%) | Risiko kehilangan informasi |
| Hapus kolom | `data[, colSums(is.na(data)) == 0]` | Kolom dengan NA sangat banyak | Jarang disarankan |
| Imputasi mean/median | manual dengan `mean(..., na.rm=TRUE)` | MCAR/MAR, data numerik | Mereduksi variansi |
| Forward/backward fill | `zoo::na.locf()` | Data deret waktu (time series) | Urutan data harus bermakna |
| KNN Imputation | `VIM::kNN()` | MAR, data campuran | Lebih akurat dari mean |
| MICE (PMM) | `mice::mice()` | MAR, multivariat | Paling direkomendasikan |
| missForest | `missForest::missForest()` | MAR/MNAR, non-linear | Berbasis Random Forest |

> ⚠️ **Catatan paket:** Paket `DMwR` yang disebutkan di modul AB8 **sudah dihapus dari
> CRAN** dan tidak dapat diinstall dengan `install.packages("DMwR")` biasa. Gunakan
> **`VIM::kNN()`** sebagai pengganti untuk KNN imputation — hasilnya setara dan paket
> `VIM` sudah kita gunakan sejak Tutorial Web 2.

### Visualisasi Pola Data Hilang

Sebelum memilih teknik, selalu **visualisasikan** dulu pola NA-nya:

```r
# install.packages(c("VIM", "naniar", "mice", "missForest"))
library(VIM)
library(naniar)

# ---- Dataset airquality: dataset bawaan R dengan NA nyata ----
data("airquality")
cat("=== Struktur Dataset ===\n")
str(airquality)

cat("\n=== Jumlah NA per Kolom ===\n")
colSums(is.na(airquality))

cat("\n=== Persentase NA per Kolom ===\n")
round(colSums(is.na(airquality)) / nrow(airquality) * 100, 1)

# ---- Visualisasi 1: vis_miss() dari naniar ----
# Tampilan heatmap posisi NA di seluruh dataset
vis_miss(airquality)

# ---- Visualisasi 2: aggr() dari VIM ----
# Proporsi NA + pola kombinasi kolom mana yang hilang bersamaan
aggr(airquality,
     col      = c("#4E79A7", "#E15759"),
     numbers  = TRUE,
     sortVars = TRUE,
     labels   = names(airquality),
     cex.axis = 0.8, gap = 3,
     ylab     = c("Proporsi NA", "Pola NA"))
```

### Kode R: Perbandingan Metode Imputasi

```r
library(VIM)
library(mice)

# ---- Salin data agar aslinya tidak berubah ----
aq <- airquality

# ---- Metode 1: Hapus baris (listwise deletion) ----
aq_deleted <- na.omit(aq)
cat("Baris sebelum hapus:", nrow(aq), "\n")
cat("Baris setelah hapus :", nrow(aq_deleted), "\n")
cat("Data hilang         :", nrow(aq) - nrow(aq_deleted), "baris\n\n")

# ---- Metode 2: Imputasi Mean ----
aq_mean <- aq
aq_mean$Ozone[is.na(aq_mean$Ozone)]   <- mean(aq$Ozone,   na.rm = TRUE)
aq_mean$Solar.R[is.na(aq_mean$Solar.R)] <- mean(aq$Solar.R, na.rm = TRUE)

# ---- Metode 3: KNN Imputation (pengganti DMwR) ----
aq_knn <- kNN(aq, variable = c("Ozone", "Solar.R"), k = 5)
# kNN menambahkan kolom indikator; ambil hanya kolom asli
aq_knn <- aq_knn[, names(aq)]

# ---- Metode 4: MICE (Predictive Mean Matching) ----
set.seed(42)
imputed    <- mice(aq, m = 5, method = "pmm", maxit = 50,
                   seed = 500, printFlag = FALSE)
aq_mice    <- complete(imputed, 1)

# ---- Bandingkan mean Ozone keempat metode ----
cat("=== Perbandingan Mean Ozone Setelah Imputasi ===\n")
cat("Data asli (tanpa NA):", round(mean(aq$Ozone, na.rm = TRUE), 2), "\n")
cat("Listwise deletion   :", round(mean(aq_deleted$Ozone),       2), "\n")
cat("Imputasi Mean       :", round(mean(aq_mean$Ozone),          2), "\n")
cat("KNN (k=5)           :", round(mean(aq_knn$Ozone),           2), "\n")
cat("MICE (PMM)          :", round(mean(aq_mice$Ozone),          2), "\n")

# ---- Visualisasi distribusi sebelum vs sesudah ----
par(mfrow = c(1, 3))
hist(aq$Ozone, main = "Ozone: Asli (ada NA)",
     col = "#4E79A7", border = "white", na.rm = TRUE, xlab = "Ozone")
hist(aq_mean$Ozone, main = "Ozone: Imputasi Mean",
     col = "#F28E2B", border = "white", xlab = "Ozone")
hist(aq_mice$Ozone, main = "Ozone: Imputasi MICE",
     col = "#59A14F", border = "white", xlab = "Ozone")
par(mfrow = c(1, 1))
```

### ✅ Cek Pemahaman — Data Hilang

1. Berapa persentase NA di kolom `Ozone` dan `Solar.R`? Apakah persentase tersebut "sedikit" atau "banyak" menurut Anda?
2. Dari visualisasi `aggr()`, apakah ada pola — kolom `Ozone` dan `Solar.R` cenderung hilang **bersamaan** atau **terpisah**?
3. Bandingkan distribusi histogram ketiga metode. Metode mana yang **paling mengubah** bentuk distribusi data asli? Mengapa?
4. Mengapa imputasi mean selalu menghasilkan mean yang **persis sama** dengan rata-rata data asli?
5. **Tantangan:** Gunakan `missForest::missForest(airquality)$ximp` dan bandingkan mean Ozone-nya dengan MICE. Mana yang lebih dekat ke data asli?

---

## Sesi 2 — Analisis Regresi: Cara Eksplorasi (AB9) {#sesi2}
### ⏱ 20 menit

### Ringkasan Konsep

Analisis regresi menjawab dua pertanyaan utama:
1. **Apakah ada hubungan** antara variabel X dan Y?
2. **Seberapa kuat dan dalam arah apa** hubungan itu?

**Alur kerja eksplorasi regresi (AB9):**

```
Langkah 1: Eksplorasi Data Awal
  → summary(), histogram, scatter plot, boxplot

Langkah 2: Analisis Korelasi
  → cor(), heatmap korelasi

Langkah 3: Fit Model
  → lm(Y ~ X, data = ...)      ← regresi sederhana
  → lm(Y ~ X1 + X2, data = ...) ← regresi berganda

Langkah 4: Uji Asumsi
  → plot(model) → 4 diagnostic plots
  → normalitas residual: shapiro.test(residuals(model))
  → multikolinearitas: car::vif(model)

Langkah 5: Validasi
  → train-test split + MSE/RMSE
```

### Notasi Regresi Linear

Model regresi linear ditulis sebagai:

$$\hat{y} = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_k x_k$$

| Notasi | Dibaca | Arti |
|---|---|---|
| $\hat{y}$ | *y-hat* | Nilai prediksi variabel dependen |
| $\beta_0$ | *beta nol* (intersep) | Nilai $\hat{y}$ saat semua $x = 0$ |
| $\beta_1, \ldots, \beta_k$ | *beta satu* … *beta k* (slope/koefisien) | Perubahan $\hat{y}$ per satu satuan $x_i$, dengan $x$ lainnya konstan |
| $\epsilon$ | *epsilon* (residual/error) | Selisih $y_{aktual} - \hat{y}$ |
| $R^2$ | *R-squared* | Proporsi variansi $y$ yang dijelaskan model (0–1) |

> **Notasi di modul AB10 vs konvensi R:**
> Modul AB10 menggunakan $y = ax + b$ (konvensi matematika). Di R dan kebanyakan
> literatur statistik, ini ditulis $y = \beta_0 + \beta_1 x$ di mana $\beta_0$ adalah
> intersep ($b$) dan $\beta_1$ adalah slope ($a$). Keduanya ekivalen.

### Kode R: Eksplorasi Regresi Langkah demi Langkah

Kita gunakan dataset `mtcars` (bawaan R) — memprediksi konsumsi BBM (`mpg`) dari
berat kendaraan (`wt`) dan tenaga kuda (`hp`).

```r
library(ggplot2)

# ---- Langkah 1: Eksplorasi Data Awal ----
data(mtcars)
cat("=== Ringkasan Dataset ===\n")
summary(mtcars[, c("mpg", "wt", "hp", "cyl")])

# Distribusi variabel dependen
hist(mtcars$mpg,
     main = "Distribusi: Konsumsi BBM (mpg)",
     xlab = "Miles per Gallon",
     col  = "#4E79A7", border = "white")

# Scatter plot: hubungan wt vs mpg
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(color = "#4E79A7", size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE,
              color = "#E15759", linewidth = 1) +
  labs(
    title    = "Semakin Berat Kendaraan, Semakin Boros BBM",
    subtitle = "Hubungan negatif antara berat (wt) dan efisiensi (mpg)",
    x = "Berat Kendaraan (1000 lbs)",
    y = "Efisiensi BBM (mpg)"
  ) +
  theme_minimal()
```

```r
# ---- Langkah 2: Analisis Korelasi ----
cor_matrix <- cor(mtcars[, c("mpg", "wt", "hp", "cyl", "disp")])
cat("=== Matriks Korelasi ===\n")
round(cor_matrix, 2)

# Heatmap korelasi
# install.packages("corrplot")
library(corrplot)
corrplot(cor_matrix,
         method = "color",
         type   = "upper",
         addCoef.col = "black",
         tl.col = "black",
         col    = colorRampPalette(c("#E15759", "white", "#4E79A7"))(200),
         title  = "Heatmap Korelasi mtcars",
         mar    = c(0, 0, 1, 0))
```

```r
# ---- Langkah 3a: Regresi Linear Sederhana ----
model_simple <- lm(mpg ~ wt, data = mtcars)
cat("=== Ringkasan Model Sederhana (mpg ~ wt) ===\n")
summary(model_simple)

# Membaca output summary(lm):
# Coefficients:
#   (Intercept)  → β0: nilai mpg saat wt = 0
#   wt           → β1: perubahan mpg per satu unit wt
#
# Pr(>|t|):      → p-value; jika < 0.05, koefisien signifikan
# Multiple R-squared: proporsi variansi mpg yang dijelaskan wt
# Adjusted R-squared: R² yang disesuaikan untuk jumlah prediktor

# Ekstrak komponen penting
cat("\nKoefisien:\n")
coef(model_simple)
cat("\nR-squared:", summary(model_simple)$r.squared, "\n")
cat("Adjusted R-squared:", summary(model_simple)$adj.r.squared, "\n")

# Interpretasi langsung
b0 <- round(coef(model_simple)[1], 3)
b1 <- round(coef(model_simple)[2], 3)
cat(sprintf(
  "\nInterpretasi: mpg = %.3f + (%.3f × wt)\n", b0, b1))
cat(sprintf(
  "Setiap penambahan 1000 lbs berat, mpg berkurang %.3f unit.\n",
  abs(b1)))
```

```r
# ---- Langkah 3b: Regresi Linear Berganda ----
model_multi <- lm(mpg ~ wt + hp + cyl, data = mtcars)
cat("=== Ringkasan Model Berganda (mpg ~ wt + hp + cyl) ===\n")
summary(model_multi)

# Bandingkan R² sederhana vs berganda
cat("\nPerbandingan R²:\n")
cat("Model sederhana (wt saja)    :",
    round(summary(model_simple)$r.squared, 4), "\n")
cat("Model berganda (wt + hp + cyl):",
    round(summary(model_multi)$r.squared,  4), "\n")
```

```r
# ---- Langkah 4: Uji Asumsi ----
par(mfrow = c(2, 2))
plot(model_simple,
     col = "#4E79A7", pch = 16,
     main.title = "Diagnostic Plots: Model Sederhana")
par(mfrow = c(1, 1))

# Panduan membaca 4 diagnostic plots:
# 1. Residuals vs Fitted   → cek linearitas & homoskedastisitas
#    Ideal: titik tersebar acak di sekitar garis y=0
# 2. Q-Q Residuals         → cek normalitas residual
#    Ideal: titik mengikuti garis diagonal
# 3. Scale-Location        → cek homoskedastisitas
#    Ideal: garis merah datar, titik tersebar merata
# 4. Residuals vs Leverage → deteksi outlier berpengaruh
#    Titik di luar Cook's distance = influential points

# Uji Shapiro-Wilk pada residual
cat("=== Uji Normalitas Residual ===\n")
shapiro.test(residuals(model_simple))
# H0: residual berdistribusi normal
# Jika p > 0.05: gagal tolak H0 → asumsi normalitas terpenuhi

# Multikolinearitas (hanya untuk model berganda)
library(car)
cat("\n=== VIF (Variance Inflation Factor) ===\n")
vif(model_multi)
# VIF < 5: tidak ada multikolinearitas serius
# VIF > 10: masalah multikolinearitas perlu ditangani
```

```r
# ---- Langkah 5: Validasi Model (Train-Test Split) ----
set.seed(2024)
n <- nrow(mtcars)
train_idx   <- sample(1:n, size = round(0.7 * n))
train_data  <- mtcars[train_idx, ]
test_data   <- mtcars[-train_idx, ]

# Latih model pada data training
model_train <- lm(mpg ~ wt, data = train_data)

# Prediksi pada data testing
predictions <- predict(model_train, newdata = test_data)

# Evaluasi: RMSE dan MAE
rmse <- sqrt(mean((test_data$mpg - predictions)^2))
mae  <- mean(abs(test_data$mpg - predictions))

cat("=== Evaluasi Model pada Data Testing ===\n")
cat("RMSE (Root Mean Square Error):", round(rmse, 3), "\n")
cat("MAE  (Mean Absolute Error)   :", round(mae,  3), "\n")

# Visualisasi: Aktual vs Prediksi
ggplot(data.frame(aktual = test_data$mpg, prediksi = predictions),
       aes(x = aktual, y = prediksi)) +
  geom_point(color = "#4E79A7", size = 3) +
  geom_abline(intercept = 0, slope = 1,
              color = "#E15759", linewidth = 1, linetype = "dashed") +
  annotate("text", x = 15, y = 30,
           label = paste("RMSE =", round(rmse, 2)),
           size = 4, color = "#333333") +
  labs(
    title    = "Aktual vs Prediksi mpg — Data Testing",
    subtitle = "Garis merah: prediksi sempurna (aktual = prediksi)",
    x = "mpg Aktual", y = "mpg Prediksi"
  ) +
  theme_minimal()
```

### ✅ Cek Pemahaman — Regresi Eksplorasi

1. Dari `summary(model_simple)`, berapa nilai koefisien `wt`? Interpretasikan artinya dalam satu kalimat menggunakan konteks data (bukan simbol matematika).
2. Apakah koefisien `wt` signifikan secara statistik (p < 0.05)? Bagaimana Anda mengetahuinya dari output R?
3. Bandingkan $R^2$ model sederhana vs berganda. Apakah penambahan variabel `hp` dan `cyl` meningkatkan kemampuan model secara bermakna?
4. Dari 4 diagnostic plots, apakah asumsi **normalitas residual** terpenuhi? Apakah ada **outlier berpengaruh**?
5. **Tantangan:** Dari matriks korelasi, variabel mana yang berkorelasi paling kuat dengan `mpg`? Apakah ini konsisten dengan koefisien yang signifikan di model berganda?

---

## Sesi 3 — Analisis Regresi: Cara Konfirmasi (AB10) {#sesi3}
### ⏱ 20 menit

### Ringkasan Konsep

AB10 memperkenalkan **least squares** sebagai fondasi matematis di balik `lm()` di R.

Garis regresi $y = ax + b$ dicari dengan meminimalkan jumlah kuadrat residual:

$$a = \frac{n\sum x_i y_i - \sum x_i \sum y_i}{n\sum x_i^2 - (\sum x_i)^2}, \quad
b = \frac{1}{n}\left(\sum y_i - a\sum x_i\right)$$

| Notasi | Arti |
|---|---|
| $n$ | Jumlah pasangan data $(x, y)$ |
| $x_i, y_i$ | Nilai observasi ke-$i$ |
| $a$ | Slope (kemiringan) — setara $\beta_1$ |
| $b$ | Intersep — setara $\beta_0$ |
| $\sum$ | Penjumlahan dari $i=1$ sampai $n$ |
| $\epsilon_1, \epsilon_2$ | Residual: jarak vertikal titik data ke garis regresi |

> ⚠️ **Inkonsistensi di Modul AB10 — Contoh 2:**
> Data asli: $y$ = 12, 19, 29, 37, 45 (total $\sum y = 142$)
> Tabel perhitungan menggunakan: $y$ = 10, 13, 25, 34, 40 (total $\sum y = 122$)
>
> Kedua set data berbeda — bukan sekadar transformasi. Kode R di bawah menggunakan
> **data asli** (12, 19, 29, 37, 45) yang tertera di soal. Jalankan dan bandingkan
> hasilnya dengan solusi di modul.

### Kode R: Verifikasi Manual vs `lm()`

```r
# ===========================================================
# VERIFIKASI CONTOH 1 AB10
# Data: {(2,1), (1,1), (3,2)}
# ===========================================================
x1 <- c(2, 1, 3)
y1 <- c(1, 1, 2)
n1 <- length(x1)

# Hitung komponen rumus manual
sum_x  <- sum(x1);   sum_y  <- sum(y1)
sum_xy <- sum(x1 * y1); sum_x2 <- sum(x1^2)

a1 <- (n1 * sum_xy - sum_x * sum_y) / (n1 * sum_x2 - sum_x^2)
b1 <- (1/n1) * (sum_y - a1 * sum_x)

cat("=== Contoh 1: Perhitungan Manual ===\n")
cat("a (slope)    :", round(a1, 4), "\n")
cat("b (intersep) :", round(b1, 4), "\n")
cat("Garis regresi: y =", round(a1, 4), "x +", round(b1, 4), "\n\n")

# Verifikasi dengan lm()
model1 <- lm(y1 ~ x1)
cat("=== Contoh 1: Verifikasi lm() ===\n")
cat("Intersep (b) :", round(coef(model1)[1], 4), "\n")
cat("Slope    (a) :", round(coef(model1)[2], 4), "\n")

# Apakah hasil manual = hasil lm()? Bandingkan:
cat("\nSelisih slope   :", abs(a1 - coef(model1)[2]), "\n")
cat("Selisih intersep:", abs(b1 - coef(model1)[1]), "\n")

# Plot
plot(x1, y1, pch = 16, col = "#4E79A7", cex = 1.5,
     main = "Contoh 1: Data & Garis Regresi",
     xlab = "x", ylab = "y",
     xlim = c(0, 4), ylim = c(0, 3))
abline(model1, col = "#E15759", lwd = 2)
legend("topleft",
       legend = paste("y =", round(a1,3), "x +", round(b1,3)),
       col = "#E15759", lty = 1, lwd = 2)
```

```r
# ===========================================================
# VERIFIKASI CONTOH 2 AB10
# Data penjualan ASLI (sesuai tabel soal): 12, 19, 29, 37, 45
# x = tahun 2019–2023 → ditransformasi ke t = 0,1,2,3,4
# ===========================================================
tahun      <- c(2019, 2020, 2021, 2022, 2023)
penjualan  <- c(12, 19, 29, 37, 45)  # data ASLI dari soal

# Transformasi t = x - 2019 (mengurangi skala, bukan mengubah data)
t <- tahun - 2019
n2 <- length(t)

cat("=== Contoh 2: Data Asli ===\n")
cat("t (tahun ke-):", t, "\n")
cat("y (penjualan):", penjualan, "\n\n")

# Hitung manual
sum_t   <- sum(t);   sum_y2  <- sum(penjualan)
sum_ty  <- sum(t * penjualan); sum_t2  <- sum(t^2)

a2 <- (n2 * sum_ty - sum_t * sum_y2) / (n2 * sum_t2 - sum_t^2)
b2 <- (1/n2) * (sum_y2 - a2 * sum_t)

cat("=== Hasil Perhitungan (data asli) ===\n")
cat("a (slope)    :", round(a2, 4), "\n")
cat("b (intersep) :", round(b2, 4), "\n\n")

# Prediksi tahun 2024 (t = 5)
t_2024     <- 2024 - 2019
pred_2024  <- a2 * t_2024 + b2
cat("Prediksi penjualan 2024 (data asli):",
    round(pred_2024, 2), "miliar IDR\n")

# Verifikasi dengan lm()
model2     <- lm(penjualan ~ t)
pred_lm    <- predict(model2, newdata = data.frame(t = t_2024))
cat("Prediksi lm() 2024                :",
    round(pred_lm, 2), "miliar IDR\n")

# ---- Bandingkan dengan data modul (10,13,25,34,40) ----
penjualan_modul <- c(10, 13, 25, 34, 40)   # data di tabel modul AB10
model_modul     <- lm(penjualan_modul ~ t)
pred_modul      <- predict(model_modul,
                           newdata = data.frame(t = t_2024))
cat("\n[Perbandingan] Prediksi 2024 (data modul):",
    round(pred_modul, 2), "miliar IDR\n")
cat("→ Selisih antara dua versi data:",
    round(abs(pred_2024 - pred_modul), 2), "miliar IDR\n")

# ---- Visualisasi Tren + Prediksi ----
library(ggplot2)
plot_data <- data.frame(
  t         = c(t, t_2024),
  penjualan = c(penjualan, NA),
  tipe      = c(rep("Aktual", 5), "Prediksi")
)

ggplot() +
  # Data aktual
  geom_point(data = subset(plot_data, tipe == "Aktual"),
             aes(x = t + 2019, y = penjualan),
             color = "#4E79A7", size = 4) +
  # Garis regresi (diperpanjang ke 2024)
  geom_smooth(data = subset(plot_data, tipe == "Aktual"),
              aes(x = t + 2019, y = penjualan),
              method = "lm", se = TRUE, fullrange = TRUE,
              color = "#E15759", linewidth = 1.2) +
  # Titik prediksi
  geom_point(aes(x = 2024, y = pred_lm),
             color = "#59A14F", size = 5, shape = 18) +
  annotate("text", x = 2024, y = pred_lm + 1.5,
           label = paste0("2024: ", round(pred_lm, 1), " M"),
           color = "#59A14F", size = 3.5, fontface = "bold") +
  scale_x_continuous(breaks = 2019:2024) +
  labs(
    title    = "Tren Penjualan 2019–2023 & Prediksi 2024",
    subtitle = "Menggunakan regresi least squares | data asli modul AB10",
    x = "Tahun", y = "Penjualan (miliar IDR)"
  ) +
  theme_minimal()
```

```r
# ===========================================================
# MEMBACA OUTPUT summary(lm) SECARA LENGKAP
# ===========================================================
cat("\n=== Output Lengkap Model Penjualan ===\n")
summary(model2)

# Panduan membaca output:
#
# Call: formula yang digunakan
#
# Residuals: distribusi residu (min, Q1, median, Q3, max)
#   → Median mendekati 0 = baik
#
# Coefficients:
#   Estimate     = nilai β (koefisien)
#   Std. Error   = ketidakpastian estimasi (semakin kecil semakin baik)
#   t value      = Estimate / Std. Error
#   Pr(>|t|)     = p-value; ** atau *** = sangat signifikan
#
# Residual standard error = rata-rata besarnya error prediksi
# Multiple R-squared      = proporsi variansi y yang dijelaskan model
# F-statistic             = uji signifikansi model secara keseluruhan
# p-value (F-stat)        = jika < 0.05, model secara keseluruhan signifikan
```

### ✅ Cek Pemahaman — Regresi Konfirmasi

1. Dari Contoh 1, apakah hasil perhitungan manual ($a$ dan $b$) cocok dengan output `lm()`? Berapa selisihnya?
2. Jalankan kode Contoh 2. Berapa prediksi penjualan 2024 menggunakan data asli? Bandingkan dengan jawaban di modul (51,7 miliar). Mengapa berbeda?
3. Dari `summary(model2)`, apakah koefisien `t` (slope) signifikan? Bagaimana Anda mengetahuinya?
4. Apa arti nilai $R^2$ pada model penjualan? Apakah model ini "baik"?
5. **Tantangan:** Tambahkan data penjualan aktual 2024 (misalkan 50 miliar) ke dataset. Buat model regresi baru dengan data 2019–2024, lalu prediksi 2025. Apakah prediksi 2025 lebih atau kurang dari 60 miliar?

---

## Latihan Terpadu: Dataset Mahasiswa AVD (lanjutan) {#latihan}

Lanjutan dari Tutorial Web 2 — kini kita integrasikan penanganan data hilang
dan regresi ke dalam dataset yang sama.

```r
# ---- Buat ulang dataset mahasiswa AVD ----
set.seed(2024)
n <- 50

mahasiswa_avd <- data.frame(
  id_mahasiswa   = paste0("SI", sprintf("%03d", 1:n)),
  wilayah        = sample(c("Jawa","Sumatera","Kalimantan","Sulawesi","Lainnya"),
                          n, replace = TRUE,
                          prob = c(0.4, 0.25, 0.15, 0.12, 0.08)),
  hadir_tutorial = sample(3:8, n, replace = TRUE),
  nilai_tugas    = pmin(pmax(round(rnorm(n, 78, 10)), 40), 100),
  nilai_uts      = pmin(pmax(round(rnorm(n, 72, 12)), 40), 100),
  nilai_uas      = pmin(pmax(round(rnorm(n, 75, 11)), 40), 100)
)

# Tambahkan NA (simulasi MCAR)
set.seed(7)
mahasiswa_avd$nilai_uts[sample(1:n, 5)] <- NA
```

```r
# ---- BAGIAN A: Tangani Data Hilang Dulu ----
library(mice)

# Cek NA
cat("NA sebelum imputasi:", sum(is.na(mahasiswa_avd)), "\n")

# Imputasi MICE pada kolom numerik
set.seed(42)
mhs_imp   <- mice(mahasiswa_avd[, c("nilai_tugas","nilai_uts","nilai_uas",
                                     "hadir_tutorial")],
                  m = 3, method = "pmm", maxit = 30,
                  printFlag = FALSE)
mhs_complete <- mahasiswa_avd
mhs_complete[, c("nilai_tugas","nilai_uts","nilai_uas","hadir_tutorial")] <-
  complete(mhs_imp, 1)

cat("NA setelah imputasi:", sum(is.na(mhs_complete)), "\n")

# Hitung nilai akhir (bobot: tugas 30%, UTS 30%, UAS 40%)
mhs_complete$nilai_akhir <- with(mhs_complete,
  round(0.30 * nilai_tugas + 0.30 * nilai_uts + 0.40 * nilai_uas, 1))
```

```r
# ---- BAGIAN B: Regresi — Apakah Kehadiran Memprediksi Nilai Akhir? ----
library(ggplot2)

model_mhs <- lm(nilai_akhir ~ hadir_tutorial, data = mhs_complete)

cat("=== Model: nilai_akhir ~ hadir_tutorial ===\n")
summary(model_mhs)

# Visualisasi storytelling
b0_mhs <- round(coef(model_mhs)[1], 2)
b1_mhs <- round(coef(model_mhs)[2], 2)
r2_mhs <- round(summary(model_mhs)$r.squared, 3)
pval   <- round(summary(model_mhs)$coefficients[2, 4], 4)

ggplot(mhs_complete, aes(x = hadir_tutorial, y = nilai_akhir)) +
  geom_jitter(aes(color = nilai_akhir), width = 0.15,
              size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE,
              color = "#E15759", linewidth = 1.2) +
  scale_color_gradient(low = "#E15759", high = "#59A14F",
                       name = "Nilai Akhir") +
  annotate("text", x = 3.2, y = max(mhs_complete$nilai_akhir) - 2,
           label = paste0("y = ", b0_mhs, " + ", b1_mhs, "×hadir\n",
                          "R² = ", r2_mhs, " | p = ", pval),
           hjust = 0, size = 3.5, color = "#333333") +
  labs(
    title    = ifelse(pval < 0.05,
                      "Kehadiran Tutorial Berpengaruh Signifikan terhadap Nilai Akhir",
                      "Kehadiran Tutorial Tidak Berpengaruh Signifikan terhadap Nilai Akhir"),
    subtitle = paste0("Slope = ", b1_mhs,
                      ": setiap tambah 1 sesi hadir, nilai akhir naik ",
                      abs(b1_mhs), " poin"),
    x = "Jumlah Kehadiran Tutorial (sesi)",
    y = "Nilai Akhir"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))
```

```r
# ---- BAGIAN C: Regresi Berganda ----
model_multi_mhs <- lm(nilai_akhir ~ hadir_tutorial + nilai_tugas + nilai_uts,
                      data = mhs_complete)

cat("=== Model Berganda ===\n")
summary(model_multi_mhs)

# Bandingkan R² sederhana vs berganda
cat("\nR² sederhana (hadir saja)   :",
    round(summary(model_mhs)$r.squared, 4), "\n")
cat("R² berganda  (hadir+tugas+uts):",
    round(summary(model_multi_mhs)$r.squared, 4), "\n")

# Uji asumsi model berganda
par(mfrow = c(2, 2))
plot(model_multi_mhs, col = "#4E79A7", pch = 16)
par(mfrow = c(1, 1))

# VIF
library(car)
cat("\n=== VIF (Multikolinearitas) ===\n")
vif(model_multi_mhs)
```

### ✅ Cek Pemahaman — Latihan Terpadu

1. Setelah imputasi MICE, apakah distribusi `nilai_uts` berubah signifikan? Bandingkan mean dan SD sebelum dan sesudah.
2. Dari model sederhana `nilai_akhir ~ hadir_tutorial`: apakah hubungannya signifikan (p < 0.05)? Berapa besar efeknya per sesi kehadiran?
3. Dari model berganda: variabel mana yang **paling berpengaruh** terhadap nilai akhir berdasarkan p-value?
4. Dari 4 diagnostic plots model berganda: apakah ada asumsi yang dilanggar?
5. **Tantangan Storytelling:** Buat satu paragraf narasi (3–4 kalimat) yang merangkum temuan model regresi ini untuk dilaporkan kepada Ketua Program Studi. Bayangkan audiens Anda adalah non-statistisi.

---

## Referensi {#referensi}

**Data Hilang:**
- finnstats (2021). *Handling missing values in R*. R-bloggers.
  <https://www.r-bloggers.com/2021/04/handling-missing-values-in-r/>
- Dokumentasi paket: `?mice::mice`, `?VIM::kNN`, `?naniar::vis_miss`

**Analisis Regresi:**
- Bobbitt, Z. (2022). *How to Plot lm() Results in R*. Statology.
  <https://www.statology.org/plot-lm-in-r/>
- DataCamp (2025). *How to Do Linear Regression in R*.
  <https://www.datacamp.com/tutorial/linear-regression-R>
- SFU (2020). *Lesson 9: Simple Linear Regression*. Basic Analytics in R.
  <https://www.sfu.ca/~mjbrydon/tutorials/BAinR/regression.html>

**Paket R yang Digunakan:**
```r
install.packages(c("ggplot2", "VIM", "naniar", "mice",
                   "missForest", "corrplot", "car"))
```

> ⚠️ **Jangan gunakan `install.packages("DMwR")`** — paket ini tidak lagi tersedia
> di CRAN. Gunakan `VIM::kNN()` sebagai pengganti.

---

*Modul Tutorial Web 3 — MSIM4310 Analisis dan Visualisasi Data*
*Program Studi Sistem Informasi, Fakultas Sains dan Teknologi, Universitas Terbuka*
*Versi: Mei 2026*
