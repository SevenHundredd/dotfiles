#!/bin/sh
verse=$(curl -s "https://labs.bible.org/api/?passage=random&formatting=plain" 2>/dev/null | head -c 100)
if [ -n "$verse" ]; then
    len=${#verse}
    border=""
    i=0
    while [ $i -lt $((len + 4)) ]; do
        border="${border}─"
        i=$((i + 1))
    done
    echo "╭${border}╮"
    printf "│ \033[3;37m${verse}\033[0m │\n"
    echo "╰${border}╯"
fi
