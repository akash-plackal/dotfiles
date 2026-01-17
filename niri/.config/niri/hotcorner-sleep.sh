
#!/usr/bin/env bash

# Turn screen off immediately
wlrctl output power off

# Start idle timer for suspend
swayidle -w \
  timeout 120 'systemctl suspend' \
  resume 'wlrctl output power on'
