#!/usr/bin/env bash
set -euo pipefail


# ----------------------------
# Ensure root
# ----------------------------
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo $0"
    exit 1
fi


# ----------------------------
# Configuration
# ----------------------------
DOTFILES_REPO="$(pwd)"              # use current directory
TARGET_USER="${SUDO_USER:-$USER}"   # handle root running on behalf of a user
TARGET_HOME=$(eval echo "~${TARGET_USER}")

# package : possible executables mapping
# (we’ll check all candidates, if any exists then package is considered installed)
declare -A PACKAGE_BINARIES=(
    [neofetch]="neofetch"
    [vim]="vim"
    [git]="git"
    [curl]="curl"
    [bat]="bat batcat"   # Arch: bat, Debian: batcat
    [ripgrep]="rg"
    [git-delta]="delta"
    [nmap]="nmap"
    [tree]="tree"
)

echo "Installing packages (if missing) and linking dotfiles for $TARGET_USER."


# ----------------------------
# Install packages if missing
# ----------------------------
install_packages() {
    local missing=()

    for pkg in "${!PACKAGE_BINARIES[@]}"; do
        local found=false
        for bin in ${PACKAGE_BINARIES[$pkg]}; do
            if command -v "$bin" &>/dev/null; then
                found=true
                break
            fi
        done

        if [[ $found == false ]]; then
            missing+=("$pkg")
        fi
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        echo "All required packages are already installed."
        return
    fi

    echo "Need to install: ${missing[*]}"

    if command -v apt-get &>/dev/null; then
        apt-get update -y
        apt-get install -y "${missing[@]}"
    elif command -v dnf &>/dev/null; then
        dnf install -y "${missing[@]}"
    elif command -v yum &>/dev/null; then
        yum install -y "${missing[@]}"
    elif command -v pacman &>/dev/null; then
        pacman -Sy --noconfirm "${missing[@]}"
    elif command -v zypper &>/dev/null; then
        zypper install -y "${missing[@]}"
    elif command -v apk &>/dev/null; then
        apk add --no-cache "${missing[@]}"
    elif command -v xbps-install &>/dev/null; then
        xbps-install -Sy "${missing[@]}"
    elif command -v emerge &>/dev/null; then
        emerge --ask n "${missing[@]}"
    else
        echo "⚠️  No supported package manager found. Please install manually: ${missing[*]}"
    fi
}

install_packages


# ----------------------------
# Link dotfiles
# ----------------------------
cd "$DOTFILES_REPO"

for file in .*; do
    [[ "$file" == "." || 
        "$file" == ".." || 
        "$file" == ".git" ||
        "$file" == ".gitignore" ||
        "$file" == ".gitattributes" ]] && continue

    src="$DOTFILES_REPO/$file"
    dest="$TARGET_HOME/$file"

    if [[ -L "$dest" ]]; then
        # If it's a symlink already pointing correctly, skip
        if [[ "$(readlink "$dest")" == "$src" ]]; then
            continue
        else
            echo "Updating wrong symlink $dest -> $src"
            rm -f "$dest"
        fi
    elif [[ -e "$dest" ]]; then
        # If it’s a real file/dir, back it up
        echo "Backing up existing $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
    chown -h "$TARGET_USER:$TARGET_USER" "$dest"
done

echo "✅ Dotfiles linking complete for $TARGET_USER"

sudo -u "$TARGET_USER" bash -c "source ./user-install.sh"

