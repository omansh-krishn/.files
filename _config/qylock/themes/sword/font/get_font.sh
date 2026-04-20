#!/bin/bash

# url="https://dl.dafont.com/dl/?f=the_last_shuriken"
url="https://web.archive.org/web/20260302141445/https://dl.dafont.com/dl/?f=the_last_shuriken"
sha256="05fc3d22e03f356ee501875035bdb47774bc911031e0615899f8081951a2bbe3"
curl $url -o font.zip
file_sum=$(sha256sum font.zip | awk '{print $1}')
if [ "$file_sum" != "$sha256" ]; then
    echo "checksum mismatch, aborting..."
    exit 1
fi
command -v unzip >/dev/null && unzip font.zip || echo "unzip not found, unzip files manually..."
