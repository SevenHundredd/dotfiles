#!/bin/sh
while true; do
    clear
    fastfetch
    verse=$(curl -s "https://labs.bible.org/api/?passage=random&formatting=plain" 2>/dev/null | head -c 80)
    if [ -n "$verse" ]; then
        len=${#verse}
        width=$((len + 4))
        border=""
        i=0
        while [ $i -lt $width ]; do
            border="${border}─"
            i=$((i + 1))
        done
        echo ""
        printf "\033[38;2;179;156;137m╭${border}╮\033[0m\n"
        printf "\033[38;2;179;156;137m│\033[0m \033[3;38;2;200;190;177m${verse}\033[0m \033[38;2;179;156;137m│\033[0m\n"
        printf "\033[38;2;179;156;137m╰${border}╯\033[0m\n"
    fi
    sleep 30
done
