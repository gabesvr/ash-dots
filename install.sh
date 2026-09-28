#!/usr/bin/env bash
# Instala as dots num CachyOS + Hyprland novo.  Uso: ./install.sh
set -euo pipefail
cd "$(dirname "$0")"

PKGS=(hypr foot fish fastfetch fuzzel apps yambar fnott cava gaming thunar gtk xdg bin)

echo "==> Pacotes"
grep -vx yambar packages.txt | sudo pacman -S --needed -

echo "==> yambar (AUR; compila sem -Werror por causa do GCC novo)"
if ! command -v yambar >/dev/null; then
    tmp=$(mktemp -d); git clone -q https://aur.archlinux.org/yambar.git "$tmp"
    sed -i 's|meson ../\$pkgname \\|meson ../$pkgname -Dwerror=false \\|' "$tmp/PKGBUILD"
    gpg --recv-keys B19964FBBA09664CC81027ED5BBD4992C116573F
    (cd "$tmp" && makepkg -si --noconfirm)
fi

echo "==> Locale pt_BR (data na barra)"
sudo sed -i "s/^#pt_BR.UTF-8/pt_BR.UTF-8/" /etc/locale.gen && sudo locale-gen

echo "==> Ferramentas em C (src/): ash-tray, nvoc, mouse-hz"
make -C src
install -Dm755 src/ash-tray src/mouse-hz -t "$HOME/.local/bin"
sudo install -Dm755 src/nvoc -t /usr/local/bin

echo "==> Caminhos absolutos → $HOME"
grep -rlF /home/gabriel yambar gaming gtk | xargs -r sed -i "s|/home/gabriel|$HOME|g"

echo "==> Links (stow)"
stow -t "$HOME" "${PKGS[@]}"

echo "==> Pastas do usuário"
mkdir -p ~/{Documents/Obsidian,Downloads,Games,Music,Pictures/{Screenshots,Wallpapers},Projects,Videos}

echo "==> Sistema"
sudo install -m644 system/etc/scx_loader.toml /etc/scx_loader.toml
# Modo TURBO (ventoinhas 100%, GPU P0 + overclock) — sudo sem senha só para este script
sudo visudo -cf system/etc/sudoers.d/ash-turbo
sudo install -m755 system/usr/local/bin/ash-turbo /usr/local/bin/ash-turbo
sudo install -m440 system/etc/sudoers.d/ash-turbo /etc/sudoers.d/ash-turbo
sudo install -m644 system/etc/udev/rules.d/60-nvme-scheduler.rules /etc/udev/rules.d/
sudo install -m644 system/etc/udev/rules.d/61-gpu-nvidia-symlink.rules /etc/udev/rules.d/   # /dev/dri/nvidia-card
# Rede: BBR + buffers, Wi-Fi sem economia de energia, rtw89 sem ASPM
sudo install -m644 system/etc/sysctl.d/99-ash-network.conf /etc/sysctl.d/
sudo install -m644 system/etc/NetworkManager/conf.d/wifi-powersave-off.conf /etc/NetworkManager/conf.d/
sudo install -m644 system/etc/modprobe.d/rtw89.conf /etc/modprobe.d/
sudo sysctl --system >/dev/null
sudo install -m644 system/etc/systemd/system/ash-turbo.service /etc/systemd/system/
sudo systemctl daemon-reload && sudo systemctl enable ash-turbo.service
sudo systemctl enable --now scx_loader.service
sudo systemctl enable --now tailscaled.service
sudo tailscale set --operator="$USER"   # control-center liga/desliga sem sudo
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket NetworkManager-wait-online.service || true
sudo usermod -aG gamemode "$USER"

echo "==> Thunar (xfconf reescreve o arquivo, então vai por comando)"
T() { xfconf-query -c thunar -p "$1" -n -t "$2" -s "$3"; }
T /default-view                string ThunarDetailsView
T /last-view                   string ThunarDetailsView
T /misc-folders-first          bool   true
T /misc-middle-click-in-tab    bool   true
T /misc-show-delete-action     bool   true
T /misc-thumbnail-mode         string THUNAR_THUMBNAIL_MODE_ALWAYS
T /misc-date-style             string THUNAR_DATE_STYLE_SHORT
T /misc-full-path-in-tab-title bool   true
T /last-side-pane              string ThunarShortcutsPane
T /last-window-width           int    1000
T /last-window-height          int    640
T /last-window-maximized       bool   false

echo "==> PrismLauncher: gamemode + 4 GB de RAM (só se ainda não configurado)"
cfg=~/.local/share/PrismLauncher/prismlauncher.cfg
[[ -f $cfg ]] || { mkdir -p "${cfg%/*}"; printf '[General]\nEnableFeralGamemode=true\nMaxMemAlloc=4096\nMinMemAlloc=1024\nLanguage=pt_BR\n' > "$cfg"; }

echo "==> Tema GTK ash + ícones Papirus-Ash (pastas verde-água)"
"$HOME/.local/bin/papirus-ash" teal
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface icon-theme Papirus-Ash
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font 10"

echo "Pronto. Saia e entre de novo na sessão."
