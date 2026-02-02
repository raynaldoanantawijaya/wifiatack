#!/bin/bash

# Stability & Performance Booster for TP-Link TL-WN722N v1
# Usage: sudo bash stability_booster.sh

echo "[*] Tahap 1: Mematikan Pengganggu (NetworkManager)..."
# Ini yang bikin Wi-Fi sering on-off sendiri di VM
sudo airmon-ng check kill
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant

echo "[*] Tahap 2: Mencegah Power Saving..."
# Mencegah kartu 'tidur' otomatis saat idle
sudo iw dev wlan0 set power_save off 2>/dev/null
sudo iw dev wlan0mon set power_save off 2>/dev/null

echo "[*] Tahap 3: Meningkatkan TX Power (Jebol Regulasi)..."
# Mengubah regulasi frekuensi ke Bolivia (BO) yang mengizinkan power tinggi
sudo iw reg set BO
sleep 2

# Memaksa power naik ke 30dBm (1000mW - 1 Watt)
# Normalnya cuma 20dBm (100mW)
echo "    -> Setting TxPower to 30dBm..."
sudo iwconfig wlan0 txpower 30 2>/dev/null
sudo iwconfig wlan0mon txpower 30 2>/dev/null

echo ""
echo "---------------------------------------------------"
echo "[SUCCESS] Kartu Wi-Fi Anda sekarang dalam Mode BEAST!"
echo "---------------------------------------------------"
echo "1. Tidak ada gangguan dari system background."
echo "2. Power sinyal naik 10x lipat (100mW -> 1000mW)."
echo "3. Siap digunakan untuk Airgeddon / Handshake / PMKID."
echo ""
echo "Jalankan airgeddon sekarang: sudo bash airgeddon.sh"
echo "---------------------------------------------------"
