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

if [[ ! -d "$HOST_DIR" ]]; then
    echo "Aviso: host '$HOST_NAME' não encontrado no repositório."
    echo "Usando fallback: $REPO_ROOT/hosts/hal"
    HOST_DIR="$REPO_ROOT/hosts/hal"
fi

mkdir -p "$HOME/.config" "$HOME/.local/share/color-schemes" "$HOME/.local/share/icons/diesel-os-lab"

copy_file() {
    local src="$1"
    local dst_dir="$2"
    if [[ -f "$src" ]]; then
        cp -v "$src" "$dst_dir/"
    else
        echo "Aviso: arquivo ausente no repositório: $src"
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
        echo "Aviso: diretório ausente no repositório: $src"
    fi
}

echo
echo "==> Restaurando configuração do NixOS em /etc/nixos"
sudo cp -v "$HOST_DIR/configuration.nix" /etc/nixos/
sudo cp -v "$HOST_DIR/hardware-configuration.nix" /etc/nixos/

echo
echo "==> Restaurando arquivos do Plasma"
copy_file "$PLASMA_DIR/plasma-org.kde.plasma.desktop-appletsrc" "$HOME/.config"
copy_file "$PLASMA_DIR/kdeglobals" "$HOME/.config"
copy_file "$PLASMA_DIR/kwinrc" "$HOME/.config"
copy_file "$PLASMA_DIR/plasmarc" "$HOME/.config"
copy_file "$PLASMA_DIR/kglobalshortcutsrc" "$HOME/.config"
copy_file "$PLASMA_DIR/kscreenlockerrc" "$HOME/.config"

echo
echo "==> Restaurando arquivos GTK"
copy_file "$GTK_DIR/gtkrc-2.0" "$HOME/.config"
copy_dir "$GTK_DIR/gtk-3.0" "$HOME/.config"
copy_dir "$GTK_DIR/gtk-4.0" "$HOME/.config"

echo
echo "==> Restaurando tema e ícone"
copy_file "$THEME_DIR/DieselOSLab.colors" "$HOME/.local/share/color-schemes"
copy_file "$ICON_DIR/menu-launcher.png" "$HOME/.local/share/icons/diesel-os-lab"

cat <<MSG

Restauração concluída.

Agora siga esta ordem:
1. Revise /etc/nixos/configuration.nix
2. Rode: sudo nixos-rebuild test
3. Se estiver tudo certo, rode: sudo nixos-rebuild switch
4. Rode: bash "$REPO_ROOT/scripts/apply-diesel-plasma-theme.sh"
5. Faça logout/login no Plasma

MSG
