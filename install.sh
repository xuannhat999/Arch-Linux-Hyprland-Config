#!/bin/bash

# Dừng script nếu có lỗi xảy ra
set -e

echo "--- Bắt đầu cài đặt Dotfiles ---"

# 1. Cập nhật hệ thống
sudo pacman -Syu --noconfirm

# 2. Cài đặt các package cơ bản từ kho chính (Pacman)
PACKAGES=(
  # CORE
  "neovim"
  "stow"
  "kitty"
  "waybar"
  "hyprland"
  "gnome-keyring"
  "fcitx5-bamboo"
  "hyprlock"
  "hyprpaper"
  "hyprshot"
  "hypridle"
  "bluez"
  "bluez-utils"
  "pipewire-pulse"
  "wirepluber"
  # TUI MANAGER
  "wiremix"
  "bluetui"
  "impala"
  "yazi"
  "mako"
  "rofi"
  "rofi-calc"
  # THEME
  "papirus-icon-theme"
  "ttf-jetbrains-mono-nerd"
  "noto-fonts-cjk"
  "ttf-ms-fonts"
  # UTILS
  "tree-sitter"
  "libreoffice-fresh"
  "starship"
  "fzf"
  "zoxide"
  "lazygit"
  "lazydocker"
  "zathura"
  "zathura-pdf-mupdf"

)

echo "Đang cài đặt các package từ Pacman..."
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# 3. Cài đặt AUR Helper (nếu chưa có)
if ! command -v yay &>/dev/null; then
  echo "Đang cài đặt yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd -
fi

# 4. Cài đặt các package từ AUR
AUR_PACKAGES=(
  "catppuccin-gtk-theme-mocha"
  "brave-bin"
  "android_studio"
)

echo "Đang cài đặt các package từ AUR..."
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
echo "--- Cài đặt hoàn tất! ---"
