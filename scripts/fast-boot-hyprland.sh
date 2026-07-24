#!/usr/bin/env bash
# Speeds up boot (shorter Limine menu timeout, tty1 autologin) and makes fish
# the login shell, which auto-execs Hyprland on tty1 (see ~/.config/fish/config.fish).
#
# Needs sudo + your account password interactively, so run it yourself in a
# real terminal rather than through Claude:
#   chmod +x ~/scripts/fast-boot-hyprland.sh
#   ~/scripts/fast-boot-hyprland.sh
set -euo pipefail

LIMINE_CONF=/boot/limine/limine.conf
TIMEOUT_SECS=1
AUTOLOGIN_USER="$USER"
OVERRIDE_DIR=/etc/systemd/system/getty@tty1.service.d

echo "==> Lowering Limine boot menu timeout to ${TIMEOUT_SECS}s"
sudo sed -i "s/^timeout:.*/timeout: ${TIMEOUT_SECS}/" "$LIMINE_CONF"

echo "==> Enabling tty1 autologin for ${AUTOLOGIN_USER}"
sudo mkdir -p "$OVERRIDE_DIR"
sudo tee "$OVERRIDE_DIR/autologin.conf" > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${AUTOLOGIN_USER} --noclear %I \$TERM
EOF
sudo systemctl daemon-reload

echo "==> Setting default shell to fish"
if [ "$SHELL" != "/usr/bin/fish" ]; then
    chsh -s /usr/bin/fish
fi

echo "Done. Reboot to see it: quick Limine timeout, autologin on tty1, fish -> Hyprland."
