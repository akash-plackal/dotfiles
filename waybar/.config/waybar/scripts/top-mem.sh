#!/usr/bin/env bash

ps -eo comm,rss --no-headers \
  | awk '{ mem[$1] += $2 } END {
      for (app in mem)
          printf "%-20s %6.1f MB\n", app, mem[app]/1024
    }' \
  | sort -k2 -nr \
  | head -n 5 \
  | notify-send "Top RAM usage (by app)" "$(cat)"

