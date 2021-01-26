#!/bin/bash

set -x

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT=$HERE
export READIES=$ROOT/deps/readies

OS=$($READIES/bin/platform --osnick)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

mkdir -p ./artifacts/snapshot
tar -czvf ./artifacts/snapshot/gears-jvm.linux-$OS-x64.$GIT_BRANCH.tgz \
	--transform "s,^./src/,./plugin/," \
	./bin/OpenJDK/jdk-11.0.9.1+1/* \
	./src/gears_jvm.so \
	./gears_runtime/target/gear_runtime-jar-with-dependencies.jar
