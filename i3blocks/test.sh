#!/usr/bin/env bash

sink_from_running_input() {
  pactl list sink-inputs |
    awk '
      /^Sink Input #/      {sink=""}
      /Sink: /             {sink=$2}
      /State: RUNNING/     {print sink; exit}
    '
}

default_sink() {
  pactl get-default-sink 2>/dev/null || pactl info | awk -F': ' '/Default Sink/ {print $2}'
}

describe_sink() {
  local sink_name="$1"
  pactl list sinks |
    awk -v name="$sink_name" '
      $1=="Name:" && $2==name {in_sink=1}
      in_sink && $1=="Description:" {print substr($0, index($0,$2)); exit}
    '
}

sink="$(sink_from_running_input)"
[ -z "$sink" ] && sink="$(default_sink)"

[ -n "$sink" ] && printf '%s\n' "$(describe_sink "$sink")" || echo "No sink"
