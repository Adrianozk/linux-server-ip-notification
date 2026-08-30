#!/usr/bin/env bash
set -euo pipefail

WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
IP_ENDPOINT="${IP_ENDPOINT:-https://ifconfig.me/ip}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/linux-server-ip-notification"
STATE_FILE="$STATE_DIR/last_ip.txt"

if [[ -z "$WEBHOOK_URL" ]]; then
    echo "Error: set the DISCORD_WEBHOOK_URL environment variable." >&2
    exit 1
fi

mkdir -p "$STATE_DIR"

current_ip="$(curl --fail --silent --show-error --max-time 15 "$IP_ENDPOINT")"

if [[ -z "$current_ip" ]]; then
    echo "Error: the public IP endpoint returned an empty response." >&2
    exit 1
fi

previous_ip=""
if [[ -f "$STATE_FILE" ]]; then
    previous_ip="$(<"$STATE_FILE")"
fi

if [[ "$current_ip" == "$previous_ip" ]]; then
    echo "Public IP unchanged: $current_ip"
    exit 0
fi

payload="$(printf '{"content":"Public server IP changed to: %s"}' "$current_ip")"

curl --fail --silent --show-error \
    --request POST \
    --header "Content-Type: application/json" \
    --data "$payload" \
    "$WEBHOOK_URL"

printf '%s\n' "$current_ip" > "$STATE_FILE"
echo "Discord notification sent. Current public IP: $current_ip"
