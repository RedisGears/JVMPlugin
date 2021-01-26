#!/bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT=$HERE
export READIES=$ROOT/deps/readies

echo "installing OpenJDK"

WORK_DIR=./bin/OpenJDK/
OPEN_JDK_ZIP=OpenJDK11U-jdk_x64_linux_hotspot_11.0.9.1_1.tar.gz
OPEN_JDK_URL=https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9.1%2B1/$OPEN_JDK_ZIP

mkdir -p $WORK_DIR

if [[ -f "$WORK_DIR$OPEN_JDK_ZIP" ]]; then
    echo "Skiping OpenJDK download"
else 
    echo "Download OpenJDK"
    wget -q -P $WORK_DIR $OPEN_JDK_URL
    tar -C $WORK_DIR --no-same-owner -xf $WORK_DIR$OPEN_JDK_ZIP
fi
