#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/mnt/vmstore/projetos/Diesel-Plasma-Lab"
HOST_NAME="${HOSTNAME%%.*}"
ACTUAL_USER="${SUDO_USER:-$USER}"
USER_HOME="$(getent passwd "$ACTUAL_USER" | cut -d: -f6)"

HOST_DIR="$REPO_ROOT/hosts/$HOST_NAME"
NIXOS_DIR="$HOST_DIR/nixos"
PLASMA_DIR="$REPO_ROOT/users/$ACTUAL_USER/plasma"
BLUETOOTH_DIR="$REPO_ROOT/users/$ACTUAL_USER/bluetooth"

mkdir -p "$USER_HOME/.config"

restore_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    cp -f "$src" "$dst"
    echo "Restaurado: $src -> $dst"
  else
    echo "Aviso: backup ausente: $src"
  fi
}

restore_if_exists "$PLASMA_DIR/plasma-org.kde.plasma.desktop-appletsrc" "$USER_HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
restore_if_exists "$PLASMA_DIR/plasmashellrc" "$USER_HOME/.config/plasmashellrc"
restore_if_exists "$PLASMA_DIR/kdeglobals" "$USER_HOME/.config/kdeglobals"

restore_if_exists "$BLUETOOTH_DIR/bluedevilglobalrc" "$USER_HOME/.config/bluedevilglobalrc"
restore_if_exists "$BLUETOOTH_DIR/bluedevil.notifyrc" "$USER_HOME/.config/bluedevil.notifyrc"

if [[ -f "$NIXOS_DIR/configuration.nix" ]]; then
  sudo cp -f "$NIXOS_DIR/configuration.nix" /etc/nixos/configuration.nix
  echo "Restaurado: $NIXOS_DIR/configuration.nix -> /etc/nixos/configuration.nix"
fi

if [[ -f "$NIXOS_DIR/hardware-configuration.nix" ]]; then
  sudo cp -f "$NIXOS_DIR/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
  echo "Restaurado: $NIXOS_DIR/hardware-configuration.nix -> /etc/nixos/hardware-configuration.nix"
fi

if command -v plasmashell >/dev/null 2>&1; then
  plasmashell --replace >/dev/null 2>&1 & disown || true
fi

echo
echo "Restauração concluída."
echo "Agora rode:"
echo "  sudo nixos-rebuild test"
echo "  sudo nixos-rebuild switch"
echo
echo "Se o painel não redesenhar sozinho, faça logout/login."
