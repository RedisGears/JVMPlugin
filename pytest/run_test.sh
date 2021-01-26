#!/bin/bash

set -x
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT=$(cd $HERE/..; pwd)
export READIES=$ROOT/deps/readies

mkdir -p $ROOT/gears_tests/build
cd $ROOT/gears_tests/build
$ROOT/bin/OpenJDK/jdk-11.0.9.1+1/bin/javac -d ./ -classpath $ROOT/gears_runtime/target/gear_runtime-jar-with-dependencies.jar $ROOT/src/gears_tests/*
$ROOT/bin/OpenJDK/jdk-11.0.9.1+1/bin/jar -cvf gears_tests.jar ./gears_tests/
cd $ROOT

JVM_OPTIONS="-Djava.class.path="
JVM_OPTIONS+="$ROOT/gears_runtime/target/gear_runtime-jar-with-dependencies.jar"
# JVM_OPTIONS+=" -XX:+IdleTuningGcOnIdle"
# JVM_OPTIONS+=" -Xms10m"
# JVM_OPTIONS+=" -Xmx2048m"
# JVM_OPTIONS+=" -Xrs"
# JVM_OPTIONS+=" -Xcheck:jni"

# echo $JVM_OPTIONS
# JVM_PATH=../../../../deps/openj9-openjdk-jdk14/build/linux-x86_64-server-release/jdk/lib/server/
JVM_PATH=$ROOT/bin/OpenJDK/jdk-11.0.9.1+1/

SRC=$ROOT/src
BIN=$ROOT/bin

RLTEST_ARGS=\
	--module $BIN/RedisGears/redisgears.so \
	--module-args \
		"Plugin $SRC/gears_jvm.so \
		JvmPath $JVM_PATH JvmOptions $JVM_OPTIONS \
		Plugin $BIN/RedisGears/plugin/gears_python.so \
		CreateVenv 0 \
		PythonInstallationDir $BIN/RedisGears/" \
	--clear-logs

echo oss
python3 -m RLTest $RLTEST_ARGS "$@"

echo cluster 1 shard
python3 -m RLTest $RLTEST_ARGS --env oss-cluster --shards-count 1 "$@"

echo cluster 2 shards
python3 -m RLTest $RLTEST_ARGS --env oss-cluster --shards-count 2 "$@"

echo cluster 3 shards
python3 -m RLTest $RLTEST_ARGS --env oss-cluster --shards-count 3 "$@"

rm -rf $ROOT/bin/RedisGears/.venv-*
