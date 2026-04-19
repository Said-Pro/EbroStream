#!/bin/sh

# ألوان للتنسيق
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()  { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

progress_bar() {
    local duration=${1}
    local bars=20
    local sleep_interval=$(echo "scale=3; $duration/$bars" | bc)
    for ((i=0; i<=bars; i++)); do
        printf "${BLUE}["
        for ((j=0; j<i; j++)); do printf "█"; done
        for ((j=i; j<bars; j++)); do printf " "; done
        printf "] %3d%%${NC}\r" $((i*100/bars))
        sleep $sleep_interval
    done
    printf "\n"
}

clear
echo "=============================================="
echo "    EbroStream Installation Script"
echo "          EbroStream V1.0"
echo "=============================================="
echo ""

# ── 1. Vérification internet ──────────────────────────────
print_status "Checking internet connection..."
if ping -c 1 github.com >/dev/null 2>&1; then
    print_success "Internet connection is available"
else
    print_error "No internet connection!"
    exit 1
fi

# ── 2. Téléchargement ─────────────────────────────────────
print_status "Downloading EbroStream from GitHub..."
wget -O /tmp/EbroStream.tar.gz \
  https://github.com/ilyasM6/EboStream/raw/refs/heads/main/EboStream.tar.gz

if [ $? -ne 0 ] || [ ! -s /tmp/EbroStream.tar.gz ]; then
    print_error "Download failed or file is empty!"
    exit 1
fi
print_success "Download completed successfully"

# ── 3. Extraction dans /tmp ───────────────────────────────
print_status "Extracting archive in /tmp..."
cd /tmp || exit 1

# Supprimer toute extraction précédente
rm -rf /tmp/EbroStream "/tmp/EbroStream"

tar -xzf EbroStream.tar.gz -C /tmp/

if [ $? -ne 0 ]; then
    print_error "Extraction failed!"
    exit 1
fi
print_success "Archive extracted successfully"

# ── 4. Détecter le dossier extrait et le renommer ─────────
print_status "Detecting extracted folder..."

# Cherche le dossier extrait (nom variable selon l'archive)
EXTRACTED=$(find /tmp -maxdepth 1 -type d -name "EbroStream*" | head -n 1)

if [ -z "$EXTRACTED" ]; then
    print_error "Could not find extracted folder in /tmp!"
    exit 1
fi

print_status "Found: $EXTRACTED"

# Renommer en "STB_UNION E2" (avec espace) si pas déjà correct
if [ "$EXTRACTED" != "/tmp/EbroStream" ]; then
    mv "$EXTRACTED" "/tmp/EbroStream"
    if [ $? -ne 0 ]; then
        print_error "Rename failed!"
        exit 1
    fi
fi
print_success "Folder renamed to 'EbroStream'"

# ── 5. Transfert vers le répertoire des plugins ───────────
DEST="/usr/lib/enigma2/python/Plugins/Extensions"
print_status "Transferring to $DEST ..."

mkdir -p "$DEST"

# Supprimer l'ancienne version si elle existe
rm -rf "$DEST/EbroStream"

mv "/tmp/EbroStream" "$DEST/"

if [ $? -ne 0 ]; then
    print_error "Transfer to plugins directory failed!"
    exit 1
fi
print_success "Plugin installed at: $DEST/EbroStream"

# ── 6. Nettoyage ──────────────────────────────────────────
print_status "Cleaning temporary files..."
rm -f /tmp/EbroStream.tar.gz
print_success "Temporary files removed"

# ── 7. Redémarrage du récepteur ───────────────────────────
echo ""
print_status "Restarting the receiver..."
print_warning "Please wait while the system restarts..."
progress_bar 3

if command -v init >/dev/null 2>&1; then
    print_status "Restarting via init 4 && init 3 ..."
    init 4 && init 3
elif command -v systemctl >/dev/null 2>&1; then
    print_status "Restarting via systemctl..."
    systemctl restart enigma2
elif [ -f /etc/init.d/enigma2 ]; then
    print_status "Restarting via init.d..."
    /etc/init.d/enigma2 restart
else
    print_error "Cannot restart automatically. Please restart manually."
    exit 1
fi

echo ""
echo "=============================================="
print_success "Installation completed successfully!"
print_success "EbroStream is installed and active"
echo "=============================================="
echo ""
