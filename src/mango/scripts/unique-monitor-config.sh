#!/usr/bin/env bash
set -u

# This general idea/concept worked better on hyprland where only my setup specifically would tie in with descriptions rather than output devices
# However, with multiple monitor setups like mine, this minimizes the chance of my specific multi monitor setup clashing with anyone elses.

monitors=(
  "DP-1"      
  "HDMI-A-1"
  "DP-2"
)

all_connected() {
  local connected
  connected="$(mmsg get all-monitors 2>/dev/null | jq -r '.[].name // empty' 2>/dev/null)"
  for key in "${monitors[@]}"; do
    grep -Fq -- "$key" <<<"$connected" || return 1
  done
  return 0
}

# Wait for monitors to appear on startup
for attempt in $(seq 1 15); do
  if all_connected; then
    break
  fi
  sleep 1
done

if ! all_connected; then
  echo "unique-monitor-config: expected monitors not detected, no op" >&2
  exit 0
fi

echo -e "Connected monitors:\n$(mmsg get all-monitors 2>/dev/null | jq -r '.[].name')"

# For each monitor, focus it and switch to the corresponding tag
for index in "${!monitors[@]}"; do
  monitor="${monitors[index]}"
  tag=$((1 + index))
  echo "Setting ${monitor} to tag ${tag}"
  mmsg dispatch focusmon,"${monitor}" >/dev/null 2>&1 || true
  mmsg dispatch view,"${tag}",0 >/dev/null 2>&1 || true
done
