#!/bin/bash
# Recompila o fuzzel com scroll.patch e instala (pede a senha do sudo)
set -e
cd "$(dirname "$0")"
makepkg -sfc --noconfirm
sudo pacman -U --noconfirm fuzzel-*.pkg.tar.zst
sudo install -Dm644 fuzzel-update.hook /etc/pacman.d/hooks/fuzzel-update.hook
