# Dotfiles

Hyprland + waybar + mako + fish + kitty + rofi + nvim (kickstart), Dracula-themed throughout.

Tracked as a bare git repo over `$HOME` (not a stow/symlink setup) — `.config/**` paths in this
repo map directly to `~/.config/**` on disk.

## Fresh install

```
curl -O https://raw.githubusercontent.com/RyanLead/dotfiles/main/install.sh
bash install.sh
```

This clones the bare repo to `~/.dotfiles`, checks it out into `$HOME` (backing up any
conflicting existing files to `~/.dotfiles-backup/`), and installs everything listed in
`packages.txt` via `pacman`.

Requires a package that ships `hyprland` >= 0.55 (native Lua config support — `hyprland.lua` is
not stock `hyprlang` syntax). `paru` (AUR helper) ships directly on CachyOS repos; on vanilla Arch
you'll need to bootstrap an AUR helper manually before running the script, since `paru` itself
isn't in the official repos there.

After it finishes:
- Restart your shell (or re-login) so fish picks up `config.fish`
- Run `fisher update` to pull down fish plugin sources
- Open `nvim` once to let `lazy.nvim` bootstrap plugins
- Log into Hyprland — waybar/mako/swaybg/hyprpolkitagent autostart from `hyprland.lua`

## Notes

- `hyprland.lua` hardcodes the monitor (`DP-1 @ 3840x2160@240`) — update the `hl.monitor({...})`
  block for different hardware.
- Ongoing edits: use the `dotfiles` fish function (`git --git-dir=$HOME/.dotfiles
  --work-tree=$HOME ...`). Never `dotfiles add -A` / `add .` — the work-tree is your whole home
  directory, so a blanket add will try to stage caches and other junk. Add files by explicit path.
- Repo-root `.gitignore` is `*` (ignore everything by default) so untracked home-directory noise
  never shows up in `dotfiles status` — this is what makes explicit-path `add`s safe to rely on.
