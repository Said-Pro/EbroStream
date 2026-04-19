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
    local sleep_interval=$(echo "scale=3; $duration/$bars" | bc 2>/dev/null || echo "0.15")
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
wget -O /tmp/EbroStream.tar.gz https://github.com/Said-Pro/EbroStream/raw/refs/heads/main/EbroStream.tar.gz

if [ $? -ne 0 ] || [ ! -s /tmp/EbroStream.tar.gz ]; then
    print_error "Download failed or file is empty!"
    exit 1
fi
print_success "Download completed successfully"

# ── 3. Extraction dans /tmp ───────────────────────────────
print_status "Extracting archive in /tmp..."
cd /tmp || exit 1

# Supprimer toute extraction précédente
rm -rf /tmp/EbroStream

tar -xzf EbroStream.tar.gz

if [ $? -ne 0 ]; then
    print_error "Extraction failed!"
    exit 1
fi
print_success "Archive extracted successfully"

# ── 4. Détecter le dossier extrait et le renommer ─────────
print_status "Detecting extracted folder..."

# Cherche tout dossier ou fichier extrait
EXTRACTED=""
cd /tmp

# Chercher un dossier contenant EbroStream
EXTRACTED=$(find /tmp -maxdepth 1 -type d -name "*EbroStream*" ! -path /tmp | head -n 1)

# Si aucun dossier trouvé, chercher des fichiers extraits
if [ -z "$EXTRACTED" ]; then
    print_warning "No folder found, checking for extracted files..."
    
    # Vérifier si des fichiers ont été extraits directement
    if [ "$(ls -A /tmp | grep -v "EbroStream.tar.gz" | head -1)" ]; then
        print_status "Files extracted directly, creating folder structure..."
        mkdir -p /tmp/EbroStream
        # Déplacer tous les fichiers/dossiers extraits (sauf l'archive)
        for item in $(ls -A /tmp | grep -v "EbroStream.tar.gz"); do
            mv "/tmp/$item" "/tmp/EbroStream/" 2>/dev/null
        done
        EXTRACTED="/tmp/EbroStream"
    fi
fi

# Si toujours rien trouvé, tenter une extraction alternative
if [ -z "$EXTRACTED" ]; then
    print_warning "Attempting alternative extraction method..."
    mkdir -p /tmp/EbroStream
    tar -xzf EbroStream.tar.gz -C /tmp/EbroStream --strip-components=1 2>/dev/null
    if [ $? -eq 0 ] && [ "$(ls -A /tmp/EbroStream 2>/dev/null)" ]; then
        EXTRACTED="/tmp/EbroStream"
    fi
fi

if [ -z "$EXTRACTED" ]; then
    print_error "Could not find extracted content in /tmp!"
    print_error "Archive content preview:"
    tar -tzf EbroStream.tar.gz | head -5
    exit 1
fi

print_status "Found: $EXTRACTED"

# Renommer en "EbroStream" si pas déjà correct
if [ "$EXTRACTED" != "/tmp/EbroStream" ]; then
    rm -rf /tmp/EbroStream 2>/dev/null
    mv "$EXTRACTED" "/tmp/EbroStream"
    if [ $? -ne 0 ]; then
        print_error "Rename failed!"
        exit 1
    fi
fi
print_success "Folder renamed to 'EbroStream'"

# ── 5. Vérification du contenu ─────────────────────────────
print_status "Verifying plugin content..."
if [ ! -d "/tmp/EbroStream" ] || [ -z "$(ls -A /tmp/EbroStream)" ]; then
    print_error "Plugin folder is empty!"
    exit 1
fi
print_success "Plugin content verified"

# ── 6. Transfert vers le répertoire des plugins ───────────
DEST="/usr/lib/enigma2/python/Plugins/Extensions"
print_status "Transferring to $DEST ..."

# Vérifier que le répertoire destination existe
if [ ! -d "/usr/lib/enigma2/python/Plugins" ]; then
    print_error "Enigma2 Plugins directory not found!"
    print_error "This script must be run on an Enigma2 receiver."
    exit 1
fi

mkdir -p "$DEST"

# Sauvegarde de l'ancienne version si elle existe
if [ -d "$DEST/EbroStream" ]; then
    print_status "Backing up old version..."
    BACKUP_DIR="$DEST/EbroStream.bak.$(date +%Y%m%d_%H%M%S)"
    mv "$DEST/EbroStream" "$BACKUP_DIR"
    print_success "Backup saved to: $BACKUP_DIR"
fi

# Installation du nouveau plugin
mv "/tmp/EbroStream" "$DEST/"

if [ $? -ne 0 ]; then
    print_error "Transfer to plugins directory failed!"
    # Restaurer la sauvegarde si l'installation échoue
    if [ -d "$BACKUP_DIR" ]; then
        mv "$BACKUP_DIR" "$DEST/EbroStream"
        print_warning "Old version restored"
    fi
    exit 1
fi
print_success "Plugin installed at: $DEST/EbroStream"

# ── 7. Nettoyage ──────────────────────────────────────────
print_status "Cleaning temporary files..."
rm -f /tmp/EbroStream.tar.gz
rm -rf /tmp/EbroStream 2>/dev/null
print_success "Temporary files removed"

# ── 8. Redémarrage du récepteur ───────────────────────────
echo ""
print_status "Restarting the receiver..."
print_warning "Please wait while the system restarts..."
progress_bar 3

# Redémarrage plus robuste
if command -v init >/dev/null 2>&1; then
    print_status "Restarting via init..."
    init 4
    sleep 2
    init 3
elif command -v systemctl >/dev/null 2>&1; then
    print_status "Restarting via systemctl..."
    systemctl restart enigma2
elif [ -f /etc/init.d/enigma2 ]; then
    print_status "Restarting via init.d..."
    /etc/init.d/enigma2 restart
else
    print_warning "Cannot restart automatically. Please restart manually."
    print_warning "Run: init 4 && sleep 2 && init 3"
    exit 0
fi

echo ""
echo "=============================================="
print_success "Installation completed successfully!"
print_success "EbroStream is installed and active"
echo "=============================================="
echo ""
