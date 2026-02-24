#!/bin/bash

STATUS_DIR="$HOME/.config/sway/status"
NET_IF="wlp4s0"

mkdir -p "$STATUS_DIR"


[ -f "$STATUS_DIR/.rx_bytes" ] || cat /sys/class/net/$NET_IF/statistics/rx_bytes > "$STATUS_DIR/.rx_bytes"
[ -f "$STATUS_DIR/.tx_bytes" ] || cat /sys/class/net/$NET_IF/statistics/tx_bytes > "$STATUS_DIR/.tx_bytes"
[ -f "$STATUS_DIR/.stat" ] || cat /proc/stat > "$STATUS_DIR/.stat"

while true; do

    date=$(date +'%Y-%m-%d | %H:%M:%S')

    # --- Network ---
    rx_now=$(cat /sys/class/net/$NET_IF/statistics/rx_bytes)
    rx_prev=$(cat "$STATUS_DIR/.rx_bytes")
    rx_delta=$((rx_now - rx_prev))
    printf "%s" "$rx_now" > "$STATUS_DIR/.rx_bytes"
    rx_delta=$(printf "%8sB/s" "$rx_delta")

    tx_now=$(cat /sys/class/net/$NET_IF/statistics/tx_bytes)
    tx_prev=$(cat "$STATUS_DIR/.tx_bytes")
    tx_delta=$((tx_now - tx_prev))
    printf "%s" "$tx_now" > "$STATUS_DIR/.tx_bytes"
    tx_delta=$(printf "%8sB/s" "$tx_delta")

    # --- RAM ---
    ram_total=$(free -h --si | awk 'NR==2 {print $2}')
    ram_used=$(free -h --si | awk 'NR==2 {print $3}')
    ram_percent=$(free | awk 'NR==2 {printf "%.1f", $3*100/$2}')
    ram_pretty=$(printf "%5s%% (%s / %s)" "$ram_percent" "$ram_used" "$ram_total")

    # --- CPU temp ---
    hwmon_path=$(for hw in /sys/class/hwmon/hwmon*; do
        if [ "$(cat $hw/name)" = "coretemp" ]; then
            echo $hw
        fi
    done)

    # --- Batteries ---
    bat0="N/A"
    bat1="N/A"

    [ -f /sys/class/power_supply/BAT0/capacity ] && \
    bat0=$(cat /sys/class/power_supply/BAT0/capacity)

    [ -f /sys/class/power_supply/BAT1/capacity ] && \
    bat1=$(cat /sys/class/power_supply/BAT1/capacity)

    battery_pretty="BAT0: ${bat0}% BAT1: ${bat1}%"

    cpu_temp_raw=$(cat $hwmon_path/temp1_input)
    cpu_temp=$(awk "BEGIN {printf \"%.1f°C\", $cpu_temp_raw/1000}")

    # --- CPU usage ---
    cpu_now=($(awk 'NR==1 {print $2, $4, $5, $6}' /proc/stat))
    cpu_prev=($(awk 'NR==1 {print $2, $4, $5, $6}' "$STATUS_DIR/.stat"))

    cpu_active_now=$((cpu_now[0] + cpu_now[1] + cpu_now[3]))
    cpu_active_prev=$((cpu_prev[0] + cpu_prev[1] + cpu_prev[3]))

    cpu_idle_now=${cpu_now[2]}
    cpu_idle_prev=${cpu_prev[2]}

    cpu_active=$((cpu_active_now - cpu_active_prev))
    cpu_idle=$((cpu_idle_now - cpu_idle_prev))

    cpu_usage=$(awk "BEGIN {printf \"%.1f\", $cpu_active*100/($cpu_active+$cpu_idle)}")
    cpu_usage=$(printf "%5s%%" "$cpu_usage")

    cp /proc/stat "$STATUS_DIR/.stat"

    echo "| $cpu_usage & $cpu_temp | $ram_pretty | $battery_pretty | $rx_delta & $tx_delta | $date "

    sleep 1
done
