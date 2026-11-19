# Soal 4 – Performance Test JMeter (DemoQA Book Store)

Target: https://demoqa.com (Book Store API). Referensi: `Pre_Test_QA_Revised_2.1.docx.pdf` – Soal 4.

## File
| File | Fungsi |
|---|---|
| `demoqa_test.jmx` | Test plan JMeter (6 Thread Group, 1 per skenario) |
| `users.csv` | Data parameter: `username,password,isbn` (8 baris unik, password memenuhi policy) |

## Alur End-to-End (1 Transaction Controller per step)
`01_Register` (POST /Account/v1/User → 201) → `02_Login_Generate_Token` (GenerateToken + Login → 200) → `03_Browse_Search_Books` (GET /Books + GET /Book?ISBN=csv) → `04_Select_Book_Detail` → `05_Add_Book_To_Collection` (POST /Books → 201) → `06_Cleanup` (DELETE /Books?UserId, DELETE /Account/v1/User/{id} → 204).

Komponen: HTTP Request Defaults, Header Manager (JSON; `Authorization: Bearer ${token}` pada step terautentikasi), Cookie Manager, CSV Data Set Config (recycle, shared all), Uniform Random Timer (think time), JSON Extractor (`token`, `userId`, daftar `isbn` → dipilih acak via JSR223), Response/JSON Assertion (status code, `token`/`userId` tidak kosong, ISBN response = ISBN yang dikirim), Summary Report & Aggregate Report.

Setiap VU memakai akun unik: username CSV + sufiks unik (waktu + thread number) dibuat di JSR223, sehingga tidak bentrok (409/406) antar iterasi/run walau CSV hanya 8 baris dan di-recycle. Akun dihapus di cleanup.

## Cara Menjalankan
Hanya **Baseline** yang enabled; aktifkan satu Thread Group lain di GUI (matikan yang lain), atau jalankan non-GUI:
```
jmeter -n -t demoqa_test.jmx -l result.jtl -e -o report/
jmeter -n -t demoqa_test.jmx -Jstress_threads=150 -Jstress_duration=900 ...   # parameter stress
```
Properti: `-Jhost`, `-Jcsv`, `-Jstress_threads` (default 100), `-Jstress_duration` (detik, default 600).

> Catatan: demoqa.com adalah situs publik pihak ketiga. Jalankan dengan wajar (mulai dari Baseline), mungkin terkena rate-limit/WAF; error 429/5xx pada beban tinggi harus dibedakan dari bug script.

## Alasan Pemilihan Parameter
Think time rata-rata ±2–5 detik per step → 1 iterasi ≈ 20–25 detik per VU.

| # | Skenario | Threads | Ramp-Up | Loop / Duration | Alasan |
|---|---|---|---|---|---|
| 1 | Baseline | 1 | 1 s | 5 loop | 1 user = tanpa kontensi, sehingga RT adalah angka "murni" sebagai pembanding. 5 iterasi cukup untuk memvalidasi script (correlation, assertion, cleanup) dan mengambil rata-rata/percentile RT, sambil mengabaikan iterasi pertama (cold start/TLS handshake). |
| 2 | Load 10 | 10 | 10 s | 5 loop | Beban ringan (~1 user/detik). Semua user harus menyelesaikan flow; loop tetap (bukan durasi) agar jumlah transaksi pasti (50 flow) dan mudah dibandingkan dengan baseline. |
| 3 | Load 50 | 50 | 30 s | 5 loop | Ramp-up ≈ 1,7 user/detik: cukup lambat agar tidak menjadi spike, cukup cepat agar beban penuh tercapai saat sebagian besar iterasi berjalan, sehingga stabilitas dan tanda degradasi (kenaikan P90/P95, error) terlihat. 250 flow memberi sampel statistik memadai. |
| 4 | Load 100 | 100 | 60 s | 3 loop | Target kapasitas 100 concurrent users. Ramp-up 60 s (~1,7 user/detik) menghindari lonjakan koneksi serentak yang bisa memicu rate-limit palsu; 3 loop menjaga total request tetap wajar (300 flow) ke situs publik, sambil mempertahankan 100 user aktif bersamaan selama fase plateau. |
| 5 | Stress / Ramp-Up | 100 (naikkan via `-Jstress_threads`) | 60 s | Duration 600 s (loop forever) | Ramp-up 60 s sesuai soal: beban naik bertahap sehingga titik di mana RT mulai naik/error muncul bisa dikorelasikan dengan jumlah user aktif (lihat Active Threads Over Time vs RT). Berbasis durasi, bukan loop, karena user harus terus bekerja hingga load tertahan; 10 menit memberi fase tahan (~9 menit) setelah puncak. Jika 100 user belum jenuh, ulangi dengan 150/200. |
| 6 | Soak (opsional) | 25 (=25% puncak 100) | 120 s | Duration 1800 s (30 mnt) | Soal meminta 20–30% beban puncak: 25 user cukup rendah untuk tidak menyebabkan saturasi, tetapi cukup lama untuk mengungkap memory leak/degradasi bertahap, sehingga hanya tren RT/error jangka panjang yang berubah. Ramp-up 2 menit agar mulai dalam kondisi stabil. Durasi minimum 30 menit sesuai soal (naikkan ke 60 menit bila perlu). |

**Loop vs Duration:** skenario 1–4 memakai loop tetap (hasil deterministik, mudah dibandingkan); skenario 5–6 memakai durasi (scheduler) karena tujuannya mengamati perilaku sepanjang waktu.

## Metrik yang Dianalisis
Average/P90/P95 RT per Transaction, Throughput, Error %, Active Threads vs RT. Bandingkan setiap skenario dengan baseline.
