#!/bin/bash

# System Restore Script
# Usage: sudo bash restore_system.sh

echo "[*] Tahap 1: Mengembalikan Regulasi & Power..."
# Kembalikan ke default dunia (World Domain) atau Indonesia (ID)
sudo iw reg set 00
# Kembalikan TxPower ke Auto/Default (biasanya 20dBm)
sudo iwconfig wlan0 txpower auto 2>/dev/null
sudo iwconfig wlan0mon txpower auto 2>/dev/null

echo "[*] Tahap 2: Menyalakan Service Jaringan..."
# Nyalakan kembali NetworkManager untuk internet
sudo systemctl start wpa_supplicant
sudo systemctl start NetworkManager

echo "[*] Tahap 3: Cek Status..."
if systemctl is-active --quiet NetworkManager; then
    echo "[SUCCESS] NetworkManager is RUNNING."
    echo "          Silakan connect kembali ke Wi-Fi atau Wired Network."
else
    echo "[FAIL] NetworkManager gagal start."
    echo "       Coba restart VM atau jalankan: sudo service NetworkManager restart"
fi

echo ""
echo "---------------------------------------------------"
echo "System sudah kembali normal."
echo "Tips: Jika Wi-Fi belum muncul di pojok kanan atas,"
echo "      tunggu 10-20 detik atau cabut-colok USB Wi-Fi."
echo "---------------------------------------------------"
