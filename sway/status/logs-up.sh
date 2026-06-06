#!/bin/sh

# Интерфейсы
INTERFACES="wlan0 xray0 br-44cdd69e8ddb ygg0 eth0 lo"

STATUS_DIR="$HOME/.config/sway/status/net_multi"
mkdir -p "$STATUS_DIR"

# Инициализация
for iface in $INTERFACES; do
    if [ -d "/sys/class/net/$iface" ]; then
        rx_file="$STATUS_DIR/rx_$iface"
        tx_file="$STATUS_DIR/tx_$iface"
        [ -f "$rx_file" ] || cat "/sys/class/net/$iface/statistics/rx_bytes" > "$rx_file" 2>/dev/null
        [ -f "$tx_file" ] || cat "/sys/class/net/$iface/statistics/tx_bytes" > "$tx_file" 2>/dev/null
    fi
done

human_speed() {
    bytes=$1
    if [ "$bytes" -eq 0 ]; then
        printf "  0 B/s"
    elif [ "$bytes" -lt 1024 ]; then
        printf "%4d B/s" "$bytes"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$bytes 1024" | awk '{printf "%5.1f KiB/s", $1/$2}'
    else
        echo "$bytes 1048576" | awk '{printf "%5.1f MiB/s", $1/$2}'
    fi
}

while true; do
    output=""
    first=1

    for iface in $INTERFACES; do
        if [ ! -d "/sys/class/net/$iface" ]; then
            continue
        fi

        rx_file="$STATUS_DIR/rx_$iface"
        tx_file="$STATUS_DIR/tx_$iface"

        rx_now=$(cat "$rx_file" 2>/dev/null || echo 0)
        tx_now=$(cat "$tx_file" 2>/dev/null || echo 0)

        rx_current=$(cat "/sys/class/net/$iface/statistics/rx_bytes" 2>/dev/null || echo 0)
        tx_current=$(cat "/sys/class/net/$iface/statistics/tx_bytes" 2>/dev/null || echo 0)

        rx_delta=$((rx_current - rx_now))
        tx_delta=$((tx_current - tx_now))

        echo "$rx_current" > "$rx_file"
        echo "$tx_current" > "$tx_file"

        # короткое имя
        case "$iface" in
            br-*) short="br${iface##*-}" ;;
            *) short=$(echo "$iface" | cut -c1-5) ;;
        esac

        rx_str=$(human_speed "$rx_delta")
        tx_str=$(human_speed "$tx_delta")

        if [ "$first" -eq 1 ]; then
            output="$short ↓$rx_str ↑$tx_str"
            first=0
        else
            output="$output  |  $short ↓$rx_str ↑$tx_str"
        fi
    done

ping_status=""
    if [ -f /tmp/nic-beep-last ]; then
        content=$(cat /tmp/nic-beep-last)
        ts=$(echo "$content" | awk '{print $NF}')
        now=$(date +%s)
        age=$((now - ts))
        if [ "$age" -lt 6 ]; then
            info=$(echo "$content" | awk '{$NF=""; sub(/ $/, ""); print}')
            ping_status="  |  $info"
        else
            rm /tmp/nic-beep-last
        fi
    fi

    [ -z "$output" ] && output="no active interfaces"
    echo "$output$ping_status"
    sleep 2
done
