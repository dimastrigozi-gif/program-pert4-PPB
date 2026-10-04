# flutter_application_pertemuan4

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Laporan Praktikum Modul 04: Future & REST API Dasar
Nama: dimas tri ibrahul gozi

NIM: 362558302104

Kelas / Prodi: 2C / Sarjana Terapan TRPL

Mata Kuliah: Pemrograman Perangkat Bergerak (Semester 3)

1. Ringkasan Aktivitas
Praktikum Modul 4 ini jadi salah satu praktikum yang paling banyak makan waktu buat saya, tapi juga yang paling banyak ngasih pelajaran. Di modul ini saya baru pertama kali belajar ngambil data dari internet, bukan dari variabel biasa yang udah nempel di kode. Awalnya saya pikir tinggal panggil API terus tampilkan, ternyata ada banyak hal yang harus dipikirin: gimana kalau internetnya lemot, gimana kalau servernya mati, gimana kalau datanya kosong.

Aktivitas yang saya kerjakan di Fase A ini antara lain:

Menambahkan package http ke dalam proyek lewat flutter pub add http. Ini aja awalnya saya sempat error karena terminalnya masih berada di folder yang salah. Setelah saya pindah ke folder proyek yang benar (flutter_application_pertemuan4), perintahnya baru jalan lancar.

Membuat model Announcement dengan factory constructor fromJson yang saya kasih nilai cadangan pakai ?? supaya kalau ada field yang kosong dari server, aplikasinya tidak langsung crash.

Membuat service AnnouncementApi yang bertugas ngirim request GET ke https://jsonplaceholder.typicode.com/posts. Di dalamnya saya pasang .timeout() 10 detik biar kalau jaringan bermasalah, aplikasinya tidak nunggu selamanya.

Mengelola Future di dalam initState(). Ini awalnya saya bingung, kenapa harus di initState bukan di build. Setelah saya coba taruh di build, ternyata layarnya jadi muter terus dan tidak pernah selesai. Baru saya paham, karena setiap setState dipanggil, build jalan ulang, dan Future-nya ikut dibuat ulang.

Menambahkan tombol refresh di AppBar dan RefreshIndicator biar pengguna bisa muat ulang data kapan saja.

Menutup koneksi lewat dispose() supaya http.Client tidak nyangkut.

Saat menjalankan aplikasinya, saya awalnya milih opsi 1 (Windows) di flutter run, tapi malah muncul error "Unable to find suitable Visual Studio toolchain". Akhirnya saya ganti ke Chrome dengan flutter run -d chrome dan aplikasinya langsung jalan.

2. Bukti Empat Keadaan UI (Runtime)
Ini bagian yang paling saya tekankan waktu ngerjain, karena kata dosen, empat keadaan ini yang paling sering dinilai. Saya buktikan satu-satu, bukan cuma saya tebak-tebak.

A. Keadaan Memuat (Loading)
Ditampilkan saat proses ambil data masih berjalan. Di layar muncul CircularProgressIndicator berputar dan tulisan "Memuat pengumuman..." tepat di bawahnya. Saya sengaja kasih teks juga biar pengguna tahu aplikasinya masih kerja, bukan nge-hang.

![memuat](./foldermedia/Screenshot%202026-10-04%20120557.png)

B. Keadaan Berhasil (Success)
Ini kondisi normal. Data dari server berhasil diambil, di-parse jadi list Announcement, terus ditampilkan sebagai daftar kartu yang bisa digulir. Setiap kartu nampilin judul, cuplikan konten, nama penulis, dan kategori. Saya cek, datanya ada 10 pengumuman dari server.

![berhasil](./foldermedia/Screenshot%202026-10-04%20121235.png)

C. Keadaan Kosong (Empty)
Untuk uji yang ini, saya sengaja bikin service-nya balikin list kosong dengan mengubah sementara return data.map(...) jadi return []. Setelah di-refresh, muncul ikon kotak masuk abu-abu dan tulisan "Belum ada pengumuman untuk saat ini." Ini yang bikin saya sadar, daftar kosong itu bukan error, tapi juga bukan alasan buat nampilin layar putih kosong.

![kosong](./foldermedia/Screenshot%202026-10-04%20121248.png)

D. Keadaan Gagal (Error)
Ini yang paling seru. Saya ubah baseUrl jadi https://server-tidak-ada.com. Awalnya pas di-refresh, kok malah muncul daftar pengumuman lagi? Ternyata Flutter-nya masih nyimpen cache. Setelah saya ketik q di terminal buat matiin aplikasinya, terus jalanin ulang pakai flutter run -d chrome, barulah muncul layar error merah dengan tulisan "Gagal memuat: Exception: Gagal terhubung ke server." dan tombol "Coba Lagi".

![gagal](./foldermedia/Screenshot%202026-10-04%20121215.png)

3. Fitur Utama
Selain fitur wajib dari modul, ada beberapa hal yang saya tambahkan biar aplikasinya terasa lebih nyaman dipakai:

Tombol Refresh di AppBar — biar pengguna bisa muat ulang tanpa harus narik daftar.

Pull-to-Refresh — pakai RefreshIndicator, tarik daftar ke bawah buat ambil data terbaru.

Pesan Error yang Spesifik — bukan cuma bilang "Error", tapi saya bedain antara timeout dan gagal koneksi. Jadi pengguna tahu masalahnya di mana.

Nilai Cadangan di fromJson — kalau server kirim JSON yang tidak lengkap, aplikasinya tetap nampilin data dengan nilai default, tidak crash.

Filter Kategori di Memori — penyaringan dijalankan di sisi klien pakai where(), jadi tidak perlu request ulang ke server cuma buat filter.

4. Cara Menjalankan Aplikasi
Aplikasi bisa dijalankan dengan dua mode, tinggal pilih sesuai kebutuhan:

Mode Normal (ngambil data dari server):

bash
flutter run -d chrome
Mode Simulasi (data lokal, ditunda 1 detik):
Berguna buat nge-tes transisi loading tanpa butuh internet.

bash
flutter run --dart-define=SIMULASI=true
Sebelum dijalankan, jangan lupa flutter pub get dulu biar semua dependency-nya ke-download. Kalau mau pastiin kodenya bersih, jalankan flutter analyze dulu — kalau hasilnya No issues found! berarti aman.