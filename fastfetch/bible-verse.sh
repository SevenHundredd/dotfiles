#!/bin/sh
curl -s "https://labs.bible.org/api/?passage=random&formatting=plain" 2>/dev/null | head -c 120
