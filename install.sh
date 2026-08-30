#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required. Install it with your distribution package manager." >&2
    exit 1
fi

source_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/notify_ip2discord.sh"
target="/usr/local/bin/notify-ip-to-discord"

if [[ ! -f "$source_script" ]]; then
    echo "Error: notify_ip2discord.sh was not found next to install.sh." >&2
    exit 1
fi

install -Dm755 "$source_script" "$target"

echo "Installed: $target"
echo "Next steps:"
echo "  1. Export DISCORD_WEBHOOK_URL with your Discord webhook URL."
echo "  2. Run notify-ip-to-discord once to test it."
echo "  3. Add it to cron or a systemd timer."
