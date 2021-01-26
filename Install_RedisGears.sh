#!/bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT=$HERE
export READIES=$ROOT/deps/readies

OS=$($READIES/bin/platform --osnick)

echo "installing redisgears for: $OS"

WORK_DIR=./bin/RedisGears
REDISGEARS_ZIP=redisgears.linux-$OS-x64.master.zip
REDISGEARS_DEPS=redisgears-python.linux-$OS-x64.master.tgz
REDISGEARS_S3_PATH=http://redismodules.s3.amazonaws.com/redisgears/snapshots/$REDISGEARS_ZIP
REDISGEARS_DEPS_S3_PATH=http://redismodules.s3.amazonaws.com/redisgears/snapshots/$REDISGEARS_DEPS

mkdir -p $WORK_DIR

if [[ -f "$WORK_DIR$REDISGEARS_ZIP" ]]; then
    echo "Skiping RedisGears download"
else 
    echo "Download RedisGears"
    wget -q -P $WORK_DIR $REDISGEARS_S3_PATH
    unzip -q $WORK_DIR$REDISGEARS_ZIP -d $WORK_DIR
fi

if [[ -f "$WORK_DIR$REDISGEARS_DEPS" ]]; then
    echo "Skiping RedisGears download"
else 
    echo "Download RedisGears deps"
    wget -q -P $WORK_DIR $REDISGEARS_DEPS_S3_PATH
    tar -C $WORK_DIR --no-same-owner -xf $WORK_DIR/$REDISGEARS_DEPS
fi
