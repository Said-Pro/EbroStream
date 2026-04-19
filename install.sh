#!/bin/sh

# ═══════════════════════════════════════════════════════════════════════════
#                         COULEURS ET STYLES
# ═══════════════════════════════════════════════════════════════════════════

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
BLINK='\033[5m'
REVERSE='\033[7m'
DIM='\033[2m'

# ═══════════════════════════════════════════════════════════════════════════
#                         FONCTIONS D'AFFICHAGE
# ═══════════════════════════════════════════════════════════════════════════

print_status() { echo -e "${CYAN}▶${NC} ${BOLD_BLUE}INFO:${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} ${BOLD_GREEN}SUCCESS:${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} ${BOLD_RED}ERROR:${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} ${BOLD_YELLOW}WARNING:${NC} $1"; }
print_step() { echo -e "\n${BOLD_CYAN}┌────────────────────────────────────────────────────────┐${NC}"; echo -e "${BOLD_CYAN}│ ${WHITE}STEP $1${NC}"; echo -e "${BOLD_CYAN}└────────────────────────────────────────────────────────┘${NC}"; }
print_decorative() { echo -e "${BOLD_PURPLE}✦ $1 ✦${NC}"; }
print_header_section() { echo -e "\n${BOLD_WHITE}${UNDERLINE}$1${NC}"; }

# Barre de progression compatible BusyBox
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

# Animation de chargement compatible BusyBox
loading_animation() {
    local text="$1"
    local duration="$2"
    local chars="/ - \\ |"
    local end_time=$(($(date +%s) + duration))
    local i=0
    
    while [ $(date +%s) -lt $end_time ]; do
        printf "\r${CYAN}${chars:$i:1}${NC} ${BOLD_WHITE}${text}${NC}"
        i=$((i + 2))
        if [ $i -ge ${#chars} ]; then
            i=0
        fi
        sleep 0.1
    done
    printf "\r${GREEN}✓${NC} ${BOLD_GREEN}${text}${NC} ${GREEN}✓${NC}\n"
}

# Afficher un cadre décoratif
print_box() {
    local title="$1"
    local content="$2"
    local width=50
    local title_len=$(echo -n "$title" | wc -c)
    local padding=$(( (width - title_len - 4) / 2 ))
    local pad_left=""
    local pad_right=""
    local i=0
    
    while [ $i -lt $padding ]; do
        pad_left="${pad_left} "
        i=$((i + 1))
    done
    i=0
    while [ $i -lt $padding ]; do
        pad_right="${pad_right} "
        i=$((i + 1))
    done
    
    echo -e "${BOLD_CYAN}┌──────────────────────────────────────────────────┐${NC}"
    printf "${BOLD_CYAN}│${NC}${BOLD_WHITE}%s${BOLD_YELLOW} %s ${BOLD_WHITE}%s${NC}${BOLD_CYAN}│${NC}\n" "$pad_left" "$title" "$pad_right"
    echo -e "${BOLD_CYAN}├──────────────────────────────────────────────────┤${NC}"
    echo -e "${BOLD_CYAN}│${NC}  ${WHITE}$content${NC}  ${BOLD_CYAN}│${NC}"
    echo -e "${BOLD_CYAN}└──────────────────────────────────────────────────┘${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
#                         DÉBUT DU SCRIPT
# ═══════════════════════════════════════════════════════════════════════════

clear

# Bannière principale avec EBROSTREAM corrigé
echo -e "${BOLD_CYAN}"
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                                                                    ║"
echo -e "║  ${BOLD_PURPLE}███████╗██████╗ ██████╗  ██████╗ ███████╗████████╗██████╗ ███████╗ █████╗ ███╗   ███╗${BOLD_CYAN}  ║"
echo -e "║  ${BOLD_PURPLE}██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗ ████║${BOLD_CYAN}  ║"
echo -e "║  ${BOLD_PURPLE}█████╗  ██████╔╝██████╔╝██║   ██║███████╗   ██║   ██████╔╝███████╗███████║██╔████╔██║${BOLD_CYAN}  ║"
echo -e "║  ${BOLD_PURPLE}██╔══╝  ██╔══██╗██╔══██╗██║   ██║╚════██║   ██║   ██╔══██╗╚════██║██╔══██║██║╚██╔╝██║${BOLD_CYAN}  ║"
echo -e "║  ${BOLD_PURPLE}███████╗██║  ██║██║  ██║╚██████╔╝███████║   ██║   ██║  ██║███████║██║  ██║██║ ╚═╝ ██║${BOLD_CYAN}  ║"
echo -e "║  ${BOLD_PURPLE}╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝${BOLD_CYAN}  ║"
echo "║                                                                    ║"
echo -e "║                   ${BOLD_YELLOW}══════════════════════════════${BOLD_CYAN}                      ║"
echo -e "║              ${BOLD_RED}E B R O S T R E A M${NC}${BOLD_WHITE} - Streaming Plugin for Enigma2${BOLD_CYAN}        ║"
echo "║                                                                    ║"
echo "╠════════════════════════════════════════════════════════════════════╣"
echo -e "║  ${BOLD_GREEN}Developer:${NC} ${BOLD_WHITE}Said-Pro${NC}                                              ${BOLD_CYAN}║"
echo -e "║  ${BOLD_GREEN}Version:${NC}   ${BOLD_YELLOW}1.0${NC}                                                  ${BOLD_CYAN}║"
echo -e "║  ${BOLD_GREEN}License:${NC}   ${WHITE}MIT${NC}                                                    ${BOLD_CYAN}║"
echo -e "║  ${BOLD_GREEN}GitHub:${NC}    ${UNDERLINE}https://github.com/Said-Pro/EbroStream${NC}${BOLD_CYAN}         ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Animation de démarrage
loading_animation "Initializing EBROSTREAM installer" 2

echo ""
print_decorative "🚀 Starting installation process for EBROSTREAM"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 1: Vérification internet
# ═══════════════════════════════════════════════════════════════════════════

print_step "1/8"
print_header_section "🌐 Network Connectivity Check"

print_status "Checking internet connection..."
loading_animation "Testing connection to GitHub" 1

if ping -c 2 github.com >/dev/null 2>&1; then
    echo -e "${GREEN}  └─✅ Connection successful${NC}"
    echo -e "${GREEN}  └─✅ DNS resolution: OK${NC}"
    PING_TIME=$(ping -c 1 github.com 2>/dev/null | grep 'time=' | cut -d'=' -f4 | cut -d' ' -f1)
    if [ -n "$PING_TIME" ]; then
        echo -e "${GREEN}  └─✅ Network latency: ${PING_TIME}${NC}"
    fi
    print_success "Internet connection is available"
else
    print_error "No internet connection detected!"
    echo -e "${YELLOW}  └─⚠ Please check your network settings${NC}"
    exit 1
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 2: Téléchargement
# ═══════════════════════════════════════════════════════════════════════════

print_step "2/8"
print_header_section "📥 Downloading EBROSTREAM"

print_status "Fetching latest version from GitHub..."
echo -e "${DIM}  └─ Source: https://github.com/Said-Pro/EbroStream${NC}"
echo ""

# Téléchargement simple sans sed (compatible BusyBox)
print_status "Downloading file..."
wget -O /tmp/EbroStream.tar.gz https://github.com/Said-Pro/EbroStream/raw/refs/heads/main/EbroStream.tar.gz 2>&1

if [ $? -ne 0 ] || [ ! -s /tmp/EbroStream.tar.gz ]; then
    echo ""
    print_error "Download failed or file is empty!"
    exit 1
fi

# Afficher la taille du fichier
FILE_SIZE=$(ls -lh /tmp/EbroStream.tar.gz 2>/dev/null | awk '{print $5}')
if [ -z "$FILE_SIZE" ]; then
    FILE_SIZE=$(du -h /tmp/EbroStream.tar.gz 2>/dev/null | cut -f1)
fi
if [ -z "$FILE_SIZE" ]; then
    FILE_SIZE="unknown"
fi

print_success "EBROSTREAM downloaded successfully"
echo -e "${GREEN}  └─ File size: ${BOLD_WHITE}$FILE_SIZE${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 3: Extraction
# ═══════════════════════════════════════════════════════════════════════════

print_step "3/8"
print_header_section "📦 Archive Extraction"

print_status "Extracting archive in /tmp..."
cd /tmp || exit 1

# Supprimer toute extraction précédente
rm -rf /tmp/EbroStream 2>/dev/null

loading_animation "Decompressing files" 1
tar -xzf EbroStream.tar.gz

if [ $? -ne 0 ]; then
    print_error "Extraction failed!"
    exit 1
fi

print_success "Archive extracted successfully"
echo -e "${GREEN}  └─ Location: ${BOLD_WHITE}/tmp/${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 4: Détection et renommage
# ═══════════════════════════════════════════════════════════════════════════

print_step "4/8"
print_header_section "🔍 Structure Analysis"

print_status "Detecting extracted folder structure..."

# Cherche tout dossier ou fichier extrait
EXTRACTED=""
cd /tmp

# Chercher un dossier contenant EbroStream
for dir in /tmp/*EbroStream*; do
    if [ -d "$dir" ] && [ "$dir" != "/tmp/*EbroStream*" ]; then
        EXTRACTED="$dir"
        break
    fi
done

# Si aucun dossier trouvé, chercher des fichiers extraits
if [ -z "$EXTRACTED" ]; then
    print_warning "No folder found, checking for extracted files..."
    
    # Vérifier si des fichiers ont été extraits directement
    FILE_COUNT=0
    for item in /tmp/*; do
        case "$item" in
            */EbroStream.tar.gz) ;;
            */EbroStream) ;;
            *) 
                if [ -e "$item" ]; then
                    FILE_COUNT=$((FILE_COUNT + 1))
                fi
                ;;
        esac
    done
    
    if [ $FILE_COUNT -gt 0 ]; then
        print_status "Files extracted directly, creating folder structure..."
        mkdir -p /tmp/EbroStream
        # Déplacer tous les fichiers/dossiers extraits (sauf l'archive)
        for item in /tmp/*; do
            case "$item" in
                */EbroStream.tar.gz) ;;
                */EbroStream) ;;
                *)
                    if [ -e "$item" ]; then
                        mv "$item" /tmp/EbroStream/ 2>/dev/null
                    fi
                    ;;
            esac
        done
        EXTRACTED="/tmp/EbroStream"
    fi
fi

# Si toujours rien trouvé, tenter une extraction alternative
if [ -z "$EXTRACTED" ]; then
    print_warning "Attempting alternative extraction method..."
    mkdir -p /tmp/EbroStream
    tar -xzf EbroStream.tar.gz -C /tmp/EbroStream --strip-components=1 2>/dev/null
    if [ $? -eq 0 ] && [ -n "$(ls -A /tmp/EbroStream 2>/dev/null)" ]; then
        EXTRACTED="/tmp/EbroStream"
    fi
fi

if [ -z "$EXTRACTED" ]; then
    print_error "Could not find extracted content in /tmp!"
    print_error "Archive content preview:"
    tar -tzf EbroStream.tar.gz 2>/dev/null | head -5
    exit 1
fi

print_status "Found: ${BOLD_WHITE}$EXTRACTED${NC}"

# Compter les fichiers extraits
NB_FILES=$(find "$EXTRACTED" -type f 2>/dev/null | wc -l)
echo -e "${GREEN}  └─ Files detected: ${BOLD_WHITE}$NB_FILES${NC}"

# Renommer en "EbroStream" si pas déjà correct
if [ "$EXTRACTED" != "/tmp/EbroStream" ]; then
    print_status "Renaming folder..."
    rm -rf /tmp/EbroStream 2>/dev/null
    mv "$EXTRACTED" "/tmp/EbroStream"
    if [ $? -ne 0 ]; then
        print_error "Rename failed!"
        exit 1
    fi
    echo -e "${GREEN}  └─ Renamed to: ${BOLD_WHITE}/tmp/EbroStream${NC}"
fi
print_success "Folder structure ready"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 5: Vérification du contenu
# ═══════════════════════════════════════════════════════════════════════════

print_step "5/8"
print_header_section "✅ Content Validation"

print_status "Verifying EBROSTREAM content..."
if [ ! -d "/tmp/EbroStream" ] || [ -z "$(ls -A /tmp/EbroStream)" ]; then
    print_error "Plugin folder is empty!"
    exit 1
fi

# Vérifier les fichiers essentiels
print_status "Checking essential files..."
if [ -f "/tmp/EbroStream/plugin.py" ] || [ -f "/tmp/EbroStream/__init__.py" ]; then
    echo -e "${GREEN}  └─✅ Plugin entry point found${NC}"
else
    echo -e "${YELLOW}  └─⚠ No standard plugin file found (may be normal)${NC}"
fi

print_success "EBROSTREAM content verified"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 6: Installation
# ═══════════════════════════════════════════════════════════════════════════

print_step "6/8"
print_header_section "💾 Installation Process"

DEST="/usr/lib/enigma2/python/Plugins/Extensions"
print_status "Target directory: ${BOLD_WHITE}$DEST${NC}"

# Vérifier que le répertoire destination existe
if [ ! -d "/usr/lib/enigma2/python/Plugins" ]; then
    print_error "Enigma2 Plugins directory not found!"
    print_error "This script must be run on an Enigma2 receiver."
    exit 1
fi

mkdir -p "$DEST"
echo -e "${GREEN}  └─✅ Destination directory ready${NC}"

# Sauvegarde de l'ancienne version si elle existe
if [ -d "$DEST/EbroStream" ]; then
    print_warning "Previous installation detected!"
    BACKUP_DIR="$DEST/EbroStream.bak.$(date +%Y%m%d_%H%M%S)"
    print_status "Creating backup..."
    mv "$DEST/EbroStream" "$BACKUP_DIR"
    echo -e "${GREEN}  └─ Backup saved to: ${BOLD_WHITE}$BACKUP_DIR${NC}"
fi

# Installation du nouveau plugin
print_status "Installing EBROSTREAM..."
loading_animation "Copying files" 1
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

print_success "EBROSTREAM installed successfully!"
echo -e "${GREEN}  └─ Location: ${BOLD_WHITE}$DEST/EbroStream${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 7: Nettoyage
# ═══════════════════════════════════════════════════════════════════════════

print_step "7/8"
print_header_section "🧹 Cleanup"

print_status "Removing temporary files..."
rm -f /tmp/EbroStream.tar.gz
rm -rf /tmp/EbroStream 2>/dev/null
print_success "Temporary files removed"
echo -e "${GREEN}  └─ Space reclaimed: ${BOLD_WHITE}$FILE_SIZE${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# ÉTAPE 8: Redémarrage
# ═══════════════════════════════════════════════════════════════════════════

print_step "8/8"
print_header_section "🔄 System Restart"

echo ""
print_box "EBROSTREAM" "Plugin successfully installed! Enjoy streaming ✨"
echo ""

print_warning "The receiver will restart to apply changes"
print_status "Restarting in 3 seconds..."
echo ""

# Barre de progression avant redémarrage
progress_bar 3

# Redémarrage plus robuste
if command -v init >/dev/null 2>&1; then
    print_status "Restarting Enigma2 via init..."
    init 4
    sleep 2
    init 3
elif command -v systemctl >/dev/null 2>&1; then
    print_status "Restarting Enigma2 via systemctl..."
    systemctl restart enigma2
elif [ -f /etc/init.d/enigma2 ]; then
    print_status "Restarting Enigma2 via init.d..."
    /etc/init.d/enigma2 restart
else
    print_warning "Cannot restart automatically. Please restart manually."
    print_warning "Run: init 4 && sleep 2 && init 3"
    exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════
#                         FIN DU SCRIPT
# ═══════════════════════════════════════════════════════════════════════════

echo ""
echo -e "${BOLD_GREEN}"
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                                                                    ║"
echo "║              ✅ INSTALLATION COMPLETED SUCCESSFULLY ✅              ║"
echo "║                                                                    ║"
echo "╠════════════════════════════════════════════════════════════════════╣"
echo "║                                                                    ║"
echo -e "║  ${BOLD_YELLOW}✨ EBROSTREAM is now installed and active${NC}                         ${BOLD_GREEN}║"
echo -e "║  ${BOLD_CYAN}📺 Access the plugin from your Enigma2 menu${NC}                       ${BOLD_GREEN}║"
echo "║                                                                    ║"
echo -e "║  ${BOLD_WHITE}Developer: ${BOLD_PURPLE}Said-Pro${NC}                                                ${BOLD_GREEN}║"
echo -e "║  ${BOLD_WHITE}Version:   ${BOLD_YELLOW}1.0${NC}                                                    ${BOLD_GREEN}║"
echo "║                                                                    ║"
echo -e "║  ${BOLD_BLUE}🐛 Report issues: ${UNDERLINE}https://github.com/Said-Pro/EbroStream/issues${NC}${BOLD_GREEN}  ║"
echo "║                                                                    ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_success "Thank you for installing EBROSTREAM!"
echo ""
