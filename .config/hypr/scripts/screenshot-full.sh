#!/usr/bin/env bash
set -euo pipefail

grim - | wl-copy

notify-send "Screenshot Copied" "Copied to clipboard"
