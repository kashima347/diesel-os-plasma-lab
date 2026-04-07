#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_NAME="${HOSTNAME%%.*}"
USER_NAME="${SUDO_USER:-$USER}"

HOST_DIR="$REPO_ROOT/hosts/$HOST_NAME"
PLASMA_DIR="$REPO_ROOT/users/$USER_NAME/plasma"
GTK_DIR="$REPO_ROOT/users/$USER_NAME/gtk"
THEME_DIR="$REPO_ROOT/themes/color-schemes"
ICON_DIR="$REPO_ROOT/assets/icons"

mkdir -p "$HOST_DIR" "$PLASMA_DIR" "$GTK_DIR" "$THEME_DIR" "$ICON_DIR"

copy_file() {
    local src="$1"
    local dst_dir="$2"
    if [[ -f "$src" ]]; then
        cp -v "$src" "$dst_dir/"
    else
        echo "Aviso: arquivo ausente: $src"
    fi
}

copy_dir() {
    local src="$1"
    local dst_parent="$2"
    local name
    name="$(basename "$src")"
    if [[ -d "$src" ]]; then
        rm -rf "$dst_parent/$name"
        cp -vr "$src" "$dst_parent/"
    else
        echo "Aviso: diretório ausente: $src"
    fi
}

echo
echo "==> Copiando configuração do NixOS"
sudo cp -v /etc/nixos/configuration.nix "$HOST_DIR/"
sudo cp -v /etc/nixos/hardware-configuration.nix "$HOST_DIR/"

echo
echo "==> Copiando arquivos principais do Plasma"
copy_file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" "$PLASMA_DIR"
copy_file "$HOME/.config/kdeglobals" "$PLASMA_DIR"
copy_file "$HOME/.config/kwinrc" "$PLASMA_DIR"
copy_file "$HOME/.config/plasmarc" "$PLASMA_DIR"
copy_file "$HOME/.config/kglobalshortcutsrc" "$PLASMA_DIR"
copy_file "$HOME/.config/kscreenlockerrc" "$PLASMA_DIR"

echo
echo "==> Copiando arquivos GTK"
copy_file "$HOME/.config/gtkrc-2.0" "$GTK_DIR"
copy_dir "$HOME/.config/gtk-3.0" "$GTK_DIR"
copy_dir "$HOME/.config/gtk-4.0" "$GTK_DIR"

echo
echo "==> Copiando tema e assets locais, se existirem"
copy_file "$HOME/.local/share/color-schemes/DieselOSLab.colors" "$THEME_DIR"
copy_file "$HOME/.local/share/icons/diesel-os-lab/menu-launcher.png" "$ICON_DIR"

echo
echo "==> Estado atual do Git"
git -C "$REPO_ROOT" status --short || true
echo
echo "Backup concluído."
