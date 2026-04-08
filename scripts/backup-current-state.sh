#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/mnt/vmstore/projetos/Diesel-Plasma-Lab"
HOST_NAME="${HOSTNAME%%.*}"
ACTUAL_USER="${SUDO_USER:-$USER}"
PRIMARY_GROUP="$(id -gn "$ACTUAL_USER")"
USER_HOME="$(getent passwd "$ACTUAL_USER" | cut -d: -f6)"

HOST_DIR="$REPO_ROOT/hosts/$HOST_NAME"
NIXOS_DIR="$HOST_DIR/nixos"
PLASMA_DIR="$REPO_ROOT/users/$ACTUAL_USER/plasma"
BLUETOOTH_DIR="$REPO_ROOT/users/$ACTUAL_USER/bluetooth"

mkdir -p "$NIXOS_DIR" "$PLASMA_DIR" "$BLUETOOTH_DIR"

copy_if_exists() {
  local src="$1"
  local dst_dir="$2"
  if [[ -f "$src" ]]; then
    cp -f "$src" "$dst_dir/"
    echo "Copiado: $src -> $dst_dir/"
  else
    echo "Aviso: arquivo ausente: $src"
  fi
}

copy_if_exists "$USER_HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" "$PLASMA_DIR"
copy_if_exists "$USER_HOME/.config/plasmashellrc" "$PLASMA_DIR"
copy_if_exists "$USER_HOME/.config/kdeglobals" "$PLASMA_DIR"

copy_if_exists "$USER_HOME/.config/bluedevilglobalrc" "$BLUETOOTH_DIR"
copy_if_exists "$USER_HOME/.config/bluedevil.notifyrc" "$BLUETOOTH_DIR"

if [[ -f /etc/nixos/configuration.nix ]]; then
  sudo cp -f /etc/nixos/configuration.nix "$NIXOS_DIR/configuration.nix"
  sudo chown "$ACTUAL_USER:$PRIMARY_GROUP" "$NIXOS_DIR/configuration.nix"
  echo "Copiado: /etc/nixos/configuration.nix -> $NIXOS_DIR/configuration.nix"
fi

if [[ -f /etc/nixos/hardware-configuration.nix ]]; then
  sudo cp -f /etc/nixos/hardware-configuration.nix "$NIXOS_DIR/hardware-configuration.nix"
  sudo chown "$ACTUAL_USER:$PRIMARY_GROUP" "$NIXOS_DIR/hardware-configuration.nix"
  echo "Copiado: /etc/nixos/hardware-configuration.nix -> $NIXOS_DIR/hardware-configuration.nix"
fi

echo
echo "Backup concluído."
echo "Host: $HOST_NAME"
echo "Usuário: $ACTUAL_USER"
