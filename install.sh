#!/usr/bin/env bash
# Bootstraps this dotfiles repo onto a fresh Arch/CachyOS install.
#
# Usage:
#   curl -O https://raw.githubusercontent.com/RyanLead/dotfiles/main/install.sh
#   bash install.sh
set -euo pipefail

REPO="git@github.com:RyanLead/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

dotfiles() {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "==> Cloning dotfiles bare repo"
if [ -d "$DOTFILES_DIR" ]; then
    echo "    $DOTFILES_DIR already exists, skipping clone"
else
    git clone --bare "$REPO" "$DOTFILES_DIR"
fi

dotfiles config status.showUntrackedFiles no

echo "==> Checking out dotfiles into \$HOME"
if ! dotfiles checkout; then
    echo "    Existing files would be overwritten - backing them up to ~/.dotfiles-backup/"
    backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
        mkdir -p "$backup_dir/$(dirname "$file")"
        mv "$HOME/$file" "$backup_dir/$file"
    done
    dotfiles checkout
fi

echo "==> Installing packages (requires sudo)"
grep -vE '^\s*#|^\s*$' "$HOME/packages.txt" | grep -v '^paru$' | sudo pacman -S --needed -

echo "==> Installing paru (AUR helper)"
if ! sudo pacman -S --needed paru 2>/dev/null; then
    echo "    paru isn't in your repos (only ships via CachyOS repos out of the box)."
    echo "    On vanilla Arch, bootstrap it manually first, see README."
fi

echo "==> Done. Next steps:"
echo "    - Restart your shell (or log out/in) to pick up the fish config"
echo "    - Run 'fisher update' to fetch fish plugin sources"
echo "    - Launch nvim once to let lazy.nvim bootstrap plugins"
echo "    - Run ~/scripts/fast-boot-hyprland.sh yourself (needs interactive sudo) for"
echo "      fast Limine boot, tty1 autologin, and fish -> Hyprland autostart"
echo "    - Log into Hyprland to start waybar/mako/etc. automatically"
