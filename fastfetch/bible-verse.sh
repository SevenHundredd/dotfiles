#!/bin/sh
verse=$(curl -s "https://labs.bible.org/api/?passage=random&formatting=plain" 2>/dev/null | head -c 100)
if [ -n "$verse" ]; then
    echo "╭─────────────────────────────────────────╮"
    printf "│ \033[3;37m%-39s\033[0m │\n" "$verse"
    echo "╰─────────────────────────────────────────╯"
fi
