#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="DieselOSLab"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCHEME_SOURCE="$SCRIPT_DIR/color-schemes/${THEME_NAME}.colors"
ICON_SOURCE="$SCRIPT_DIR/assets/menu-launcher.png"
SCHEME_DEST_DIR="$HOME/.local/share/color-schemes"
ICON_DEST_DIR="$HOME/.local/share/icons/diesel-os-lab"
ICON_DEST="$ICON_DEST_DIR/menu-launcher.png"

pick_cmd() {
  for c in "$@"; do
    if command -v "$c" >/dev/null 2>&1; then
      printf '%s' "$c"
      return 0
    fi
  done
  return 1
}

KWRITECONFIG="$(pick_cmd kwriteconfig6 kwriteconfig5 kwriteconfig || true)"
KQUITAPP="$(pick_cmd kquitapp6 kquitapp5 kquitapp || true)"
KSTART="$(pick_cmd kstart6 kstart5 kstart || true)"

mkdir -p "$SCHEME_DEST_DIR" "$ICON_DEST_DIR"
install -m 0644 "$SCHEME_SOURCE" "$SCHEME_DEST_DIR/${THEME_NAME}.colors"
install -m 0644 "$ICON_SOURCE" "$ICON_DEST"

echo "Esquema instalado em: $SCHEME_DEST_DIR/${THEME_NAME}.colors"
echo "Ícone do lançador instalado em: $ICON_DEST"

if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
  plasma-apply-colorscheme "$THEME_NAME" || true
fi

if [[ -n "$KWRITECONFIG" ]]; then
  "$KWRITECONFIG" --file kdeglobals --group General --key ColorScheme "$THEME_NAME"
  "$KWRITECONFIG" --file kdeglobals --group KDE --key widgetStyle Breeze || true
fi

# Tenta reiniciar o plasmashell para aplicar imediatamente.
if pgrep -x plasmashell >/dev/null 2>&1; then
  if [[ -n "$KQUITAPP" ]]; then
    "$KQUITAPP" plasmashell || true
  else
    pkill plasmashell || true
  fi
  sleep 2
  if [[ -n "$KSTART" ]]; then
    nohup "$KSTART" plasmashell >/dev/null 2>&1 &
  else
    nohup plasmashell >/dev/null 2>&1 &
  fi
fi

cat <<MSG

Tema aplicado.

Observações:
- O esquema de cores do Plasma já foi instalado e aplicado.
- O ícone do lançador foi copiado para:
  $ICON_DEST
- Se o menu não refletir tudo na hora, faça logout e login.
- Para usar o ícone no lançador do menu, escolha este arquivo manualmente nas configurações do lançador:
  $ICON_DEST

MSG
