#!/bin/sh

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                          COULEURS ET STYLES
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

# Couleurs de base
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
NC='\033[0m' # No Color

# Couleurs en gras
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Styles
UNDERLINE='\033[4m'
DIM='\033[2m'

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                         FONCTIONS D'AFFICHAGE
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_status() { echo -e "${CYAN}▶${NC} ${BOLD_BLUE}INFO:${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} ${BOLD_GREEN}SUCCESS:${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} ${BOLD_RED}ERROR:${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} ${BOLD_YELLOW}WARNING:${NC} $1"; }
print_step() { echo -e "\n${BOLD_CYAN}════════════════════════════════════════════════════════════════${NC}"; echo -e "${BOLD_WHITE}  STEP $1${NC}"; echo -e "${BOLD_CYAN}════════════════════════════════════════════════════════════════${NC}"; }

# Barre de progression
progress_bar() {
    local duration=${1}
    local bars=20
    local sleep_interval=$(echo "scale=2; $duration/$bars" | bc 2>/dev/null || echo "0.15")
    local i=0
    
    while [ $i -le $bars ]; do
        printf "\r${BOLD_CYAN}["
        j=0
        while [ $j -lt $i ]; do
            printf "${GREEN}█${NC}"
            j=$((j + 1))
        done
        while [ $j -lt $bars ]; do
            printf "${DIM}░${NC}"
            j=$((j + 1))
        done
        printf "] ${BOLD_YELLOW}%3d%%${NC}" $((i * 100 / bars))
        i=$((i + 1))
        sleep $sleep_interval
    done
    printf "\n"
}

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                              DÉBUT DU SCRIPT
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

clear

# Bannière principale
echo -e "${BOLD_CYAN}"
echo "╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                                                                       ║"
echo -e "║  ${BOLD_GREEN}███████╗██████╗ ██████╗  ██████╗ ███████╗████████╗██████╗ ███████╗ █████╗ ███╗   ███╗${BOLD_CYAN}   ║"
echo -e "║  ${BOLD_GREEN}██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗ ████║${BOLD_CYAN}   ║"
echo -e "║  ${BOLD_RED}█████╗  ██████╔╝██████╔╝██║   ██║███████╗   ██║   ██████╔╝███████╗███████║██╔████╔██║${BOLD_CYAN}   ║"
echo -e "║  ${BOLD_RED}██╔══╝  ██╔══██╗██╔══██╗██║   ██║╚════██║   ██║   ██╔══██╗██╔═══  ██╔══██║██║╚██╔╝██║${BOLD_CYAN}   ║"
echo -e "║  ${BOLD_GREEN}███████╗███████║██║  ██║╚██████╔╝███████║   ██║   ██║  ██║███████║██║  ██║██║ ╚═╝ ██║${BOLD_CYAN}   ║"
echo -e "║  ${BOLD_GREEN}╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝${BOLD_CYAN}   ║"
echo "║                                                                                                                       ║"
echo -e "║                              ${BOLD_YELLOW}══════════════════════════════${BOLD_CYAN}                              ║"
echo -e "║              ${BOLD_RED}E B R O S T R E A M${NC}${BOLD_WHITE} - Streaming Plugin for Enigma2${BOLD_CYAN}           ║"
echo "║                                                                                                                       ║"
echo "╠═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣"
echo -e "║  ${BOLD_RED}Developer:${NC} ${BOLD_WHITE}Said-MS${NC}                                               ${BOLD_CYAN} ║"
echo -e "║  ${BOLD_RED}Version:${NC}   ${BOLD_YELLOW}4.2.1${NC}                                                  ${BOLD_CYAN} ║"
echo -e "║  ${BOLD_RED}GitHub:${NC}    ${UNDERLINE}https://github.com/Said-Pro/EbroStream${NC}${BOLD_CYAN}                  ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo ""
echo -e "${BOLD_PURPLE}✦ Starting installation of EBROSTREAM ✦${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                ÉTAPE 1: Vérification internet
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_step "1/5"
print_status "Checking internet connection..."

if ping -c 2 github.com >/dev/null 2>&1; then
    print_success "Internet connection OK"
else
    print_error "No internet connection!"
    exit 1
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                   ÉTAPE 2: Téléchargement
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_step "2/5"
print_status "Downloading EBROSTREAM from GitHub..."

ZIP_FILE="/tmp/EbroStream_update.zip"
ZIP_URL="https://github.com/Said-Pro/EbroStream/raw/refs/heads/main/EbroStream_update_v4.2.1.zip"

# Nettoyer les anciens fichiers
rm -f "$ZIP_FILE"
rm -rf /tmp/EbroStream_extracted

# Téléchargement
if command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$ZIP_FILE" "$ZIP_URL"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$ZIP_FILE" "$ZIP_URL"
else
    print_error "wget or curl not found!"
    exit 1
fi

if [ ! -f "$ZIP_FILE" ] || [ ! -s "$ZIP_FILE" ]; then
    print_error "Download failed!"
    exit 1
fi

FILE_SIZE=$(ls -lh "$ZIP_FILE" | awk '{print $5}')
print_success "Downloaded: $FILE_SIZE"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                   ÉTAPE 3: Extraction
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_step "3/5"
print_status "Extracting archive..."

# Créer un dossier temporaire pour l'extraction
EXTRACT_DIR="/tmp/EbroStream_extracted"
mkdir -p "$EXTRACT_DIR"

# Extraction du ZIP
if command -v unzip >/dev/null 2>&1; then
    unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR/" >/dev/null 2>&1
elif command -v busybox >/dev/null 2>&1 && busybox --list | grep -q unzip; then
    busybox unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR/" >/dev/null 2>&1
else
    # Fallback Python
    python3 -c "
import zipfile
import os
with zipfile.ZipFile('$ZIP_FILE', 'r') as zf:
    zf.extractall('$EXTRACT_DIR/')
" 2>/dev/null
fi

# Vérifier l'extraction
if [ ! -d "$EXTRACT_DIR" ] || [ -z "$(ls -A "$EXTRACT_DIR" 2>/dev/null)" ]; then
    print_error "Extraction failed!"
    exit 1
fi

print_success "Archive extracted"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                               ÉTAPE 4: Installation
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_step "4/5"
print_status "Installing plugin..."

DEST="/usr/lib/enigma2/python/Plugins/Extensions"

# Vérifier le répertoire de destination
if [ ! -d "/usr/lib/enigma2/python/Plugins" ]; then
    print_error "Enigma2 not found! This script must run on an Enigma2 receiver."
    exit 1
fi

mkdir -p "$DEST"

# Trouver le dossier source (peut être EbroStream, EbroStream-main, ou les fichiers directement)
SOURCE_DIR=""
cd "$EXTRACT_DIR"

# Chercher un dossier EbroStream
for dir in EbroStream EbroStream-main EbroStream-master; do
    if [ -d "$dir" ]; then
        SOURCE_DIR="$EXTRACT_DIR/$dir"
        break
    fi
done

# Si aucun dossier trouvé, prendre tout le contenu
if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR="$EXTRACT_DIR"
fi

print_status "Source: $SOURCE_DIR"

# Sauvegarder l'ancienne version
if [ -d "$DEST/EbroStream" ]; then
    print_status "Backing up old version..."
    BACKUP_DIR="/etc/enigma2/EbroStream_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$DEST/EbroStream" "$BACKUP_DIR/"
    print_success "Backup saved to $BACKUP_DIR"
    
    # Supprimer l'ancienne version
    rm -rf "$DEST/EbroStream"
fi

# Copier la nouvelle version
print_status "Copying files to $DEST/EbroStream..."
cp -rf "$SOURCE_DIR" "$DEST/EbroStream"

if [ ! -d "$DEST/EbroStream" ]; then
    print_error "Installation failed!"
    exit 1
fi

# Compter les fichiers installés
NB_FILES=$(find "$DEST/EbroStream" -type f 2>/dev/null | wc -l)
print_success "Installation complete: $NB_FILES files installed"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                              ÉTAPE 5: Nettoyage complet
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

print_step "5/5"
print_status "Cleaning temporary files..."

# Supprimer le ZIP
rm -f "$ZIP_FILE"
echo -e "${GREEN}  └─ Removed: $ZIP_FILE${NC}"

# Supprimer le dossier d'extraction
rm -rf "$EXTRACT_DIR"
echo -e "${GREEN}  └─ Removed: $EXTRACT_DIR${NC}"

# Supprimer d'éventuels restes
rm -rf /tmp/EbroStream 2>/dev/null
rm -f /tmp/EbroStream*.zip 2>/dev/null

print_success "All temporary files removed"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
#                                                                        Redémarrage
# ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

echo ""
echo -e "${BOLD_GREEN}╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD_GREEN}║                                                                                                                       ║${NC}"
echo -e "${BOLD_GREEN}║                                     ✅ INSTALLATION COMPLETED SUCCESSFULLY ✅                                        ║${NC}"
echo -e "${BOLD_GREEN}║                                                                                                                       ║${NC}"
echo -e "${BOLD_GREEN}║                               EBROSTREAM is now installed in:                                                         ║${NC}"
echo -e "${BOLD_GREEN}║                               $DEST/EbroStream${NC}                                      ║${NC}"
echo -e "${BOLD_GREEN}║                                                                                                                       ║${NC}"
echo -e "${BOLD_GREEN}╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

print_warning "Restarting Enigma2 in 3 seconds..."
progress_bar 3

# Redémarrage d'Enigma2
print_status "Restarting Enigma2..."

# Tuer Enigma2 (il redémarre automatiquement)
killall -9 enigma2 2>/dev/null

# Si killall ne fonctionne pas, essayer init
if [ $? -ne 0 ]; then
    init 4
    sleep 2
    init 3
fi

# Fin du script (le redémarrage coupe l'exécution)
exit 0
