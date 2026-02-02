#!/bin/bash

# Stability & Performance Booster v2.0 (Van Helsing Edition)
# Optimized for TP-Link TL-WN722N v1 (ath9k_htc)
# Usage: sudo bash stability_booster.sh

echo "[*] Tahap 1: Hard Recovery Driver (Fix Drop/Hide Issues)..."
# Mematikan monitor mode jika ada
sudo airmon-ng stop wlan0mon > /dev/null 2>&1
sudo airmon-ng stop wlan1mon > /dev/null 2>&1

# Refresh Driver dengan nohwcrypt=1 (Rahasia Kestabilan ath9k)
echo "    -> Reloading ath9k_htc with nohwcrypt=1..."
sudo modprobe -r ath9k_htc 2>/dev/null
sleep 2
sudo modprobe ath9k_htc nohwcrypt=1

echo "[*] Tahap 2: Mematikan Pengganggu Sistem..."
sudo airmon-ng check kill
sudo systemctl stop NetworkManager
sudo systemctl mask NetworkManager
sudo systemctl stop wpa_supplicant
sudo systemctl mask wpa_supplicant

# Deteksi nama interface otomatis
IFACE=$(iw dev | grep Interface | awk '{print $2}' | head -n 1)

if [ -z "$IFACE" ]; then
    echo "[!] ERROR: Kartu WiFi tidak terdeteksi. Silakan cabut-pasang USB Anda."
    exit 1
fi

echo "[*] Tahap 3: Konfigurasi Interface $IFACE..."
sudo iw reg set ID  # Regional Indonesia
sudo iw dev $IFACE set power_save off 2>/dev/null

echo "[*] Tahap 4: Mengaktifkan Monitor Mode..."
sudo airmon-ng start $IFACE > /dev/null 2>&1

# Deteksi nama monitor interface
MON_IFACE=$(iw dev | grep Interface | awk '{print $2}' | grep mon | head -n 1)
if [ -z "$MON_IFACE" ]; then MON_IFACE=$IFACE; fi

echo "[*] Tahap 5: Optimasi Sinyal pada $MON_IFACE..."
# TL-WN722N v1 stabil di 20dBm (Default High)
sudo iwconfig $MON_IFACE txpower 20 2>/dev/null

echo ""
echo "---------------------------------------------------"
echo "[SUCCESS] WiFi Anda Sekaran Stabil & Siap Tempur!"
echo "---------------------------------------------------"
echo "1. Driver ath9k sekarang pakai Software Cryptography (Anti-Crash)."
echo "2. Power Management DIMATIKAN (Anti-Tidur)."
echo "3. NetworkManager DIMASK (Anti-Gangguan)."
echo ""
echo "Jalankan van_helsing sekarang: sudo bash van_helsing.sh"
echo "---------------------------------------------------"
