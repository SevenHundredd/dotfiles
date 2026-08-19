#!/bin/sh
verse=$(curl -s "https://labs.bible.org/api/?passage=random&formatting=plain" 2>/dev/null | head -c 100)
if [ -n "$verse" ]; then
    printf "%*s\n" $(( ($(tput cols) + ${#verse}) / 2 )) "$verse"
fi
