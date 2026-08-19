#!/bin/sh
state="$HOME/.cache/myx/state.json"
if [ -f "$state" ]; then
    title=$(grep -o '"title":"[^"]*"' "$state" | head -1 | cut -d'"' -f4)
    artist=$(grep -o '"artist":"[^"]*"' "$state" | head -1 | cut -d'"' -f4)
    if [ -n "$title" ]; then
        echo "$title — $artist"
    else
        echo "Not playing"
    fi
else
    echo "myx not running"
fi
