# STEP 1: Builder Stage - Untuk mengklon repositori dan menyiapkan kode
# Kita bisa menggunakan image yang lebih ringan seperti alpine/git jika hanya untuk git clone
FROM alpine/git as builder

# Mengatur direktori kerja di stage builder
WORKDIR /app-source

# Mengklon repositori aplikasi dari GitHub
RUN git clone https://github.com/andhit-r/php-contact.git .

# STEP 2: Final Application Stage - Membuat image aplikasi yang sebenarnya
FROM php:8.3-apache

# Mengatur direktori kerja root web Apache
WORKDIR /var/www/html

# Menyalin isi dari folder 'public/' dari stage 'builder'
# ke direktori root web Apache di stage ini.
COPY --from=builder /app-source/public/ /var/www/html/

# Menyalin konfigurasi Apache kustom ke lokasi yang benar
# Asumsi: 000-default.conf berada di samping Dockerfile ini saat build.
# Ini harus tetap di luar stage 'builder' jika 000-default.conf ada di context build lokal.
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Port 80 sudah diekspos secara default oleh image php:apache
EXPOSE 80

# Apache akan otomatis berjalan saat container dimulai
