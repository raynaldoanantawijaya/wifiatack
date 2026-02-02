# Panduan Master: Van Helsing & Wi-Fi Hacking (Lengkap)

Ini adalah kitab utama Anda. Berisi semua langkah dari nol sampai sukses, termasuk penggunaan Portal Custom dan Script PMKID Buatan.

---

## BAB 1: Persiapan & Start (Wajib Dilakukan Tiap Kali)
Agar tidak error atau Wi-Fi hilang-hilang di VM.

1.  **Buka Terminal** Kali Linux.
## BAB 1: Persiapan & Booster (PENTING)
Lakukan ini **setiap kali** baru menyalakan Kali Linux agar performa maksimal dan Wi-Fi stabil.

1.  **Copy Script Booster** ke folder Van Helsing.
2.  **Jalankan Scriptnya**:
    ```bash
    # Ini akan mematikan semua gangguan & menaikkan power sinyal
    sudo bash stability_booster.sh
    ```
3.  **Baru Jalankan Van Helsing**:
    ```bash
    sudo bash Van Helsing.sh
    ```

---

## BAB 2: Menu Awal (Setting Up)
Setiap kali masuk `Van Helsing`, lakukan urutan ini dulu:

1.  **Select Language**: Ketik `1` (English).
2.  **Check Tools**: Tekan `Enter` sampai masuk menu utama.
3.  **Select Interface**: Ketik `4` (Pilih **wlan0** / Atheros).
4.  **Set Monitor Mode**: Ketik `2` (Penting! Status harus "Monitor Mode: On").

---

## BAB 3: SERANGAN UTAMA - Evil Twin (Portal Palsu)
Ini serangan andalan untuk mencuri password dengan menipu korban.

### A. Persiapan (Sebelum Serangan)
Pastikan Anda sudah punya file **Handshake** target. Kalau belum punya, lihat **BAB 4** dulu.

### B. Memasang Portal Custom (IndiHome/Wifi.id/dll)
Sebelum menyerang, pilih dulu mau pakai tampilan apa.

*   **Pakai IndiHome**: Jalankan perintah ini di tab terminal baru (Ctrl+Shift+T):
    ```bash
    # Asumsi file ada di Desktop/indihome_portal
    cp -r ~/Desktop/indihome_portal/* ~/Van Helsing/www/captiveportals/es/
    ```
    *(Kita "membajak" slot bahasa Spanyol)*

*   **Pakai Wifi.id**:
    ```bash
    cp -r ~/Desktop/wifi_id_portal/* ~/Van Helsing/www/captiveportals/fr/
    ```
    *(Kita "membajak" slot bahasa Prancis)*

### C. Eksekusi Serangan
Di menu utama Van Helsing:
1.  Pilih Menu `7` (**Evil Twin attacks**).
2.  Pilih Menu `9` (**Captive portal attack**).
3.  **Scan Target**: Tekan Enter -> Tunggu target muncul -> Ctrl+C.
4.  **Pilih Target**: Ketik nomor target (misal `12`).
5.  **Pilih Deauth**: Ketik `1` (**mdk4** - Paling Kuat).
6.  **Jawab Pertanyaan Script**:
    *   **DoS Pursuit?**: `n` (Kita cuma punya 1 kartu Wi-Fi).
    *   **Spoof MAC?**: `n` (Ribet untuk pemula, skip aja).
    *   **Handshake File?**: `y` (Penting! Untuk validasi password).
        *   Masukkan path: `/root/handshake-NAMA_TARGET.cap`
        *   (Biasanya script otomatis mendeteksi kalau file-nya ada di `/root/`).
    *   **Permissive Mode?**: `n` (Jika ditanya).
    *   **Internet Access?**: `n` (Biar korban gak bisa internetan selain buka portal kita).
    *   **Language**:
        *   Pilih `2` (**Spanish**) -> Jika tadi pasang **IndiHome**.
        *   Pilih `3` (**French**) -> Jika tadi pasang **Wifi.id**.
    *   **Advanced Portal?**: `n` (Penting! Pilih No biar gambar logo kita gak ditimpa script).

**Hasil:**
Jendela-jendela kecil terbuka. Tunggu sampai ada bunyi/tulisan **MATCH FOUND!**. Password tersimpan di `/root/`.

---

## BAB 4: Handshake Capture (Kunci Rumah)
Kalau belum punya handshake, lakukan ini dulu.

1.  Di Menu Utama, pilih Menu `5` (**Handshake/PMKID tools**).
2.  Pilih Menu `6` (**Capture Handshake**).
3.  **Scan**: Cari target yang ada `(*)` (artinya ada user aktif).
4.  **Pilih Target & Metode**: Pilih target -> Pilih `1` (Deauth aireplay).
5.  Tunggu **20-30 detik**.
6.  Jika sukses, muncul `Congratulations!`. Simpan file di default path (`/root/...`).

---

## BAB 5: PMKID Attack (Serangan Tanpa User)
Kalau target sepi (gak ada orang connect), pakai cara ini.

### Cara Manual (Lebih Powerfull - Pakai Script Super)
Saya sudah buatkan script khusus biar lebih tembus router baru.

1.  Tutup Van Helsing.
2.  Buka Terminal biasa.
3.  Jalankan script super:
    ```bash
    # Asumsi script ada di folder ini
    sudo bash super_pmkid.sh wlan0
    ```
4.  Tunggu 10 menit.
5.  Cek file hasil: `hash_pmkid.hc22000`.

### Cara Crack (Buka Kunci PMKID)
Dapat file PMKID belum berarti dapat password (masih terkunci). Anda butuh PC kuat (VGA Card Bagus) untuk membukanya.
1.  Copy file `.hc22000` ke Windows/PC Gaming Anda.
2.  Download **Hashcat** di Windows.
3.  Jalankan perintah (di CMD Windows):
    ```powershell
    hashcat.exe -m 22000 -a 0 hash_pmkid.hc22000 wordlist.txt
    ```
    *(Butuh file `wordlist.txt` berisi tebakan password umum).*

---

## BAB 6: Beres-beres (PENTING)
Setelah selesai main hacker-hackeran, kembalikan laptop ke kondisi normal.

1.  Di Van Helsing: Tekan `Ctrl+C` di terminal utama -> Pilih Menu `3` (Managed Mode) -> Exit.
2.  **Jalankan Script Restore**:
    ```bash
    # Ini akan menyalakan internet & mereset power Wi-Fi ke normal
    sudo bash restore_system.sh
    ```
3.  Cek pojok kanan atas Kali Linux, ikon Wi-Fi/LAN harusnya sudah muncul lagi.

**Selamat Belajar & Gunakan dengan Bijak!**
