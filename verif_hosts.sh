#!/bin/bash
# Verifica adresele IP dintr-un fisier hosts primit ca parametru

if [ $# -ne 1 ]; then
    echo "Utilizare: $0 fisier_hosts"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Eroare: fisierul $1 nu exista"
    exit 1
fi

fisier="$1"

while read -r ip rest; do
    # sarim peste liniile goale si peste comentarii
    if [ -z "$ip" ] || [ "${ip:0:1}" = "#" ]; then
        continue
    fi
    # adresele IPv6 (contin ":") nu le verificam
    if [[ "$ip" == *:* ]]; then
        continue
    fi
    if [[ "$ip" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]] &&
       [ "${BASH_REMATCH[1]}" -le 255 ] && [ "${BASH_REMATCH[2]}" -le 255 ] &&
       [ "${BASH_REMATCH[3]}" -le 255 ] && [ "${BASH_REMATCH[4]}" -le 255 ]; then
        echo "$ip - valida"
    else
        echo "$ip - INVALIDA"
    fi
done < "$fisier"
