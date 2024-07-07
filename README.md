# Newton Solver

Newton Solver adalah aplikasi Flutter untuk menyelesaikan persamaan matematika menggunakan metode Newton. Aplikasi ini memungkinkan pengguna untuk memasukkan persamaan, nilai awal (`x0`), dan toleransi kesalahan (`error`) untuk menemukan solusi persamaan. Aplikasi juga menyimpan solusi yang telah dihitung sehingga dapat diakses kembali di kemudian hari.

## Dibuat Oleh
- Renaldy (2106020)
- Fahmi (2106121)
- Sadam (2106127)

## Fitur
- Input persamaan, nilai awal (`x0`), dan toleransi kesalahan (`error`).
- Penyelesaian persamaan menggunakan metode Newton-Raphson.
- Penyimpanan solusi ke database SQLite.
- Penampilan daftar solusi yang telah disimpan.
- Penghapusan solusi yang telah disimpan.

## Instalasi
Clone repositori ini:
   ```
   sh
   git clone https://github.com/Renaldyazhari08/Metode-Newton-RSF-.git
   cd Metode-Newton-RSF-
   flutter pub get
   flutter run
   ```
## Penggunaan
- Buka aplikasi Newton Solver.
- Masukkan persamaan yang ingin diselesaikan pada kolom "Persamaan".
- Masukkan nilai awal (x0) pada kolom "Nilai x0".
- Masukkan toleransi kesalahan (error) pada kolom "Nilai Error".
- Klik tombol "Solve" untuk menyelesaikan persamaan.
- Hasil solusi dan iterasi akan ditampilkan di layar.
- Klik tombol "Save" untuk menyimpan solusi.
- Klik ikon folder di pojok kanan atas untuk membuka daftar solusi yang telah disimpan.

## Screenshot
![image](https://github.com/Renaldyazhari08/Metode-Newton-RSF-/assets/126949059/db965798-2f0d-4e3e-b225-a2be80775409)
![image](https://github.com/Renaldyazhari08/Metode-Newton-RSF-/assets/126949059/a3a7e820-0d67-499a-8d62-03916002b99e)
![image](https://github.com/Renaldyazhari08/Metode-Newton-RSF-/assets/126949059/016ab6d8-062f-4238-ab87-f62d3ee2d6c6)
![image](https://github.com/Renaldyazhari08/Metode-Newton-RSF-/assets/126949059/c8cd9664-c8c3-4e90-ac51-962dc557dd59)

## Teknologi yang digunakan
- Flutter
- Dart
- SQLite
- math_expressions

