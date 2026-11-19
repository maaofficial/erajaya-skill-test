# QA Automation & Performance Testing - Pre-Test Assessment

Repositori ini berisi hasil pengerjaan **Pre-Test Quality Assurance (QA Engineer)** yang mencakup pengujian manual (*Test Case Design*), otomatisasi pengujian web (*Web Automation*), otomatisasi pengujian aplikasi mobile (*Mobile Automation*), serta pengujian performa (*Performance Testing*).

---

## 📋 Daftar Isi

1. [Ringkasan Proyek](#-ringkasan-proyek)
2. [Struktur Direktori](#-struktur-direktori)
3. [Prasyarat & Dependensi](#-prasyarat--dependensi)
4. [Panduan Modul & Cara Menjalankan](#-panduan-modul--cara-menjalankan)
   - [01. Test Case Design (Manual Testing)](#01-test-case-design-manual-testing)
   - [02. Web Automation (CURA Healthcare)](#02-web-automation-cura-healthcare)
   - [03. Mobile Automation (Eraspace Android App)](#03-mobile-automation-eraspace-android-app)
   - [04. Performance Testing (DemoQA API JMeter)](#04-performance-testing-demoqa-api-jmeter)
5. [Keamanan & Git Best Practices](#-keamanan--git-best-practices)

---

## 📌 Ringkasan Proyek

| Modul | Target Aplikasi / Sistem | Tools & Tech Stack | Pola / Desain |
|---|---|---|---|
| **01_test_case** | Fitur Checkout - Metode Pembayaran COD | Google Sheets, Microsoft Excel (.xlsx) | Boundary Value Analysis, Equivalence Partitioning, Authorization & Quota Matrix |
| **02_web_automation** | [CURA Healthcare Service](https://katalon-demo-cura.herokuapp.com/) | Robot Framework, SeleniumLibrary, Chrome | Page Object Model (POM) |
| **03_mobile_automation** | Aplikasi Android Eraspace (`com.eraspace.app`) | Robot Framework, AppiumLibrary, Appium v2 (UiAutomator2) | Page Object Model (POM) & Dynamic Environment Config (`.env`) |
| **04_performance_test** | [DemoQA Book Store API](https://demoqa.com) | Apache JMeter 5.x, JSR223, JSON Extractor | Transaction Flow, Correlation, Parameterization, 6 Thread Groups |

---

## 📂 Struktur Direktori

```text
erajaya-skill-test/
├── .gitignore                                 # Aturan pengabaian file sensitif, output test, dan log
├── README.md                                  # Dokumentasi utama proyek
├── Pre_Test_QA_Revised_2.1.docx.pdf           # Dokumen acuan / petunjuk tes QA
│
├── 01_test_case/                              # SOAL 1: Desain Test Case Manual
│   └── Testcase Pre Test QA - Mokhamad Aulia.xlsx # Dokumen Test Case lengkap (Matrix & Test Steps)
│
├── 02_web_automation/                         # SOAL 2: Automasi Pengujian Web (CURA Healthcare)
│   ├── resources/
│   │   ├── locators/
│   │   │   └── locators.robot                 # Definisi locator elemen UI web
│   │   └── pages/
│   │       └── pages.robot                    # Keyword Page Object (Action & Validation)
│   └── tests/
│       ├── tc_login.robot                     # Skenario TC 1.1 (Invalid) & TC 1.2 (Valid Login)
│       └── tc_appointment.robot               # Skenario TC 2.1 (Mandatory Date) & TC 2.2 (Make Appointment)
│
├── 03_mobile_automation/                      # SOAL 3: Automasi Pengujian Mobile (Eraspace App)
│   ├── .env.example                           # Template variabel kredensial & konfigurasi device
│   ├── config/
│   │   └── env_loader.py                      # Parser variabel lingkungan aman (OS Env / .env)
│   ├── resources/
│   │   ├── locators/
│   │   │   └── locators.robot                 # Definisi locator UI elemen Android (XPath / Resource-ID)
│   │   └── pages/
│   │       └── pages.robot                    # Keyword Page Object (Action, Navigation, Assertions)
│   └── tests/
│       └── tc_mobile_login.robot              # Skenario TC 1.1 (Invalid Login) & TC 1.2 (Valid Login & Detail)
│
└── 04_performance_test/                       # SOAL 4: Pengujian Performa API (DemoQA Book Store)
    ├── demoqa_test.jmx                        # File Test Plan JMeter (6 Skenario Pengujian)
    ├── users.csv                              # Data set uji (Username, Password, ISBN)
    └── README.md                              # Dokumentasi teknis & analisis performa JMeter
```

---

## ⚙️ Prasyarat & Dependensi

Pastikan perangkat Anda telah terpasang:
- **Python 3.10+**
- **Google Chrome** & ChromeDriver yang sesuai
- **Node.js** & **Appium Server 2.x** dengan driver `uiautomator2`
- **Android SDK & ADB** (untuk mobile testing)
- **Apache JMeter 5.5+** & **Java JRE/JDK 11+**

### Instalasi Library Python
Jalankan perintah berikut di terminal:
```bash
pip install robotframework robotframework-seleniumlibrary robotframework-appiumlibrary
```

---

## 🚀 Panduan Modul & Cara Menjalankan

### 01. Test Case Design (Manual Testing)
- **Fokus Pengujian**: Metode pembayaran COD (*Cash on Delivery*) dengan business rules:
  - Khusus member tier **Platinum**.
  - Nominal transaksi wajib di atas **Rp 2.000.000**.
  - Kuota harian COD maksimal **1x transaksi per hari**.
- **Dokumen Test Case**:
  - 🌐 **Google Spreadsheet (Online Live View)**: [Buka Google Spreadsheet Test Case](https://docs.google.com/spreadsheets/d/18c3GE_sRWatEjixW9k_Iz6WSUfh_tJS-/edit?gid=268531683#gid=268531683)
  - 📁 **File Offline**: `01_test_case/Testcase Pre Test QA - Mokhamad Aulia.xlsx`

---

### 02. Web Automation (CURA Healthcare)
- **Target URL**: [katalon-demo-cura.herokuapp.com](https://katalon-demo-cura.herokuapp.com/)
- **Skenario Pengujian**:
  - `tc_login.robot`:
    - `TC 1.1`: Login dengan kredensial tidak valid (memastikan pesan error muncul).
    - `TC 1.2`: Login dengan kredensial valid (berhasil masuk ke halaman appointment).
  - `tc_appointment.robot`:
    - `TC 2.1`: Validasi mandatory field (memastikan input tanggal wajib diisi).
    - `TC 2.2`: Pembuatan janji temu berhasil (verifikasi rincian fasilitas, program, tanggal, dan komentar pada halaman konfirmasi).
- **Cara Menjalankan**:
  ```bash
  # Menjalankan seluruh test suite web dan menyimpan laporan di folder results/
  robot -d 02_web_automation/results 02_web_automation/tests

  # Menjalankan spesifik skenario login saja
  robot -d 02_web_automation/results 02_web_automation/tests/tc_login.robot

  # Menjalankan spesifik skenario appointment saja
  robot -d 02_web_automation/results 02_web_automation/tests/tc_appointment.robot
  ```

---

### 03. Mobile Automation (Eraspace Android App)
- **Target Aplikasi**: Eraspace Android (`com.eraspace.app`)
- **Fitur Pengujian**:
  - `TC 1.1`: Login gagal dengan kredensial tidak valid (memvalidasi pesan error).
  - `TC 1.2`: Login berhasil dengan kredensial valid, dilanjutkan dengan verifikasi tampilan Homepage, daftar navigasi menu, saldo poin, dan nama akun pengguna.
- **Konfigurasi Lingkungan (`.env`)**:
  Salin file template `.env.example` menjadi `.env` di dalam folder `03_mobile_automation/`:
  ```bash
  cp 03_mobile_automation/.env.example 03_mobile_automation/.env
  ```
  Isi nilai akun dan perangkat Anda:
  ```env
  ERASPACE_USERNAME=email_atau_nomor_hp_anda
  ERASPACE_PASSWORD=password_anda
  ERASPACE_ACCOUNT_NAME=Nama Akun Anda
  APPIUM_SERVER_URL=http://127.0.0.1:4723/wd/hub
  DEVICE_NAME=device_serial_dari_adb_devices
  ```
- **Cara Menjalankan**:
  1. Pastikan Appium server berjalan:
     ```bash
     appium
     ```
  2. Pastikan perangkat Android / Emulator terdeteksi (`adb devices`).
  3. Jalankan test suite:
     ```bash
     robot -d 03_mobile_automation/results 03_mobile_automation/tests
     ```

---

### 04. Performance Testing (DemoQA API JMeter)
- **Target URL**: [demoqa.com](https://demoqa.com) (Book Store API)
- **Alur Transaksi End-to-End**:
  1. `01_Register`: Registrasi user baru via `POST /Account/v1/User`.
  2. `02_Login_Generate_Token`: Generate token autentikasi & validasi login.
  3. `03_Browse_Search_Books`: Ambil daftar buku (`GET /Books`) dan pilih buku.
  4. `04_Select_Book_Detail`: Ambil detail buku berdasarkan ISBN.
  5. `05_Add_Book_To_Collection`: Menambahkan buku ke koleksi user (`POST /Books`).
  6. `06_Cleanup`: Menghapus koleksi buku & akun user untuk menjaga kebersihan data.
- **Daftar Thread Group / Skenario**:
  1. **Baseline**: 1 Thread / 5 Iterasi (mengukur latency murni & validasi script).
  2. **Load 10**: 10 Threads / 5 Iterasi (~1 user/detik).
  3. **Load 50**: 50 Threads / Ramp-up 30 detik.
  4. **Load 100**: 100 Concurrent Threads / Ramp-up 60 detik.
  5. **Stress / Ramp-Up**: Beban hingga 100+ user selama durasi 600 detik.
  6. **Soak Test**: Beban stabil 25% puncak (25 Threads) selama 1800 detik (30 menit).
- **Cara Menjalankan**:
  ```bash
  # Menjalankan mode CLI (Non-GUI) dan menghasilkan HTML Dashboard Report
  jmeter -n -t 04_performance_test/demoqa_test.jmx -l 04_performance_test/results.jtl -e -o 04_performance_test/report/

  # Menjalankan dengan parameter thread stress kustom
  jmeter -n -t 04_performance_test/demoqa_test.jmx -Jstress_threads=150 -Jstress_duration=900 -l 04_performance_test/results.jtl
  ```
- Dokumentasi mendalam mengenai metodologi dan analisis performa dapat dibaca pada [04_performance_test/README.md](04_performance_test/README.md).

---

## 🔒 Keamanan & Git Best Practices

Proyek ini telah dikonfigurasi agar aman dan bersih saat di-push ke GitHub:
1. **Sensitivitas Data**: File `.env` yang memuat username, password, dan token **diabaikan oleh `.gitignore`**. Hanya template `.env.example` yang di-push ke repositori.
2. **Artefak Eksekusi**: Folder hasil log Robot Framework (`results/`, `output.xml`, `log.html`, `report.html`, screenshot) serta output pengujian JMeter (`*.jtl`, `jmeter.log`, `html_report/`) otomatis diabaikan agar repositori tetap ringan dan bersih.
3. **Struktur Bersih**: Modul automasi web dan mobile menggunakan struktur Page Object Model (POM) yang rapi tanpa file pengujian duplikat.
