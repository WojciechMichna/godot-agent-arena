#!/bin/bash
set -e

BOOT_DIR="/etc/docker_boot.d"

echo "==> Starting $BOOT_DIR..."

if [ -d "$BOOT_DIR" ]; then
    # Znajdź wszystkie pliki .sh, posortuj je alfabetycznie (ważne dla kolejności 76-...)
    for script in $(find "$BOOT_DIR" -maxdepth 1 -name "*.sh" | sort); do
        if [ -x "$script" ]; then
            echo "==> Starting script: $script"
            "$script"
        else
            echo "==> Starting script bash: $script"
            bash "$script"
        fi
    done
else
    echo "==> $BOOT_DIR Dosent exist."
fi

echo "==> Procedure done."

exec "$@"
