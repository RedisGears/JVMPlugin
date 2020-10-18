#!/bin/bash
set -x

cd ./gears_tests/bin/;jar -cvf gears_tests.jar ./gears_tests/
cd ../../

JVM_OPTIONS="-Djava.class.path="
JVM_OPTIONS+="../../gears_runtime/target/gear_runtime-0.0.3-SNAPSHOT-jar-with-dependencies.jar"
#JVM_OPTIONS+=" -XX:+IdleTuningGcOnIdle";
#JVM_OPTIONS+=" -Xms10m";
#JVM_OPTIONS+=" -Xmx2048m";
#JVM_OPTIONS+=" -Xrs";
#JVM_OPTIONS+=" -Xcheck:jni";

#echo $JVM_OPTIONS
#JVM_PATH=../../../../deps/openj9-openjdk-jdk14/build/linux-x86_64-server-release/jdk/lib/server/
JVM_PATH=/var/opt/redislabs/modules/rg/999999/deps/jdk-14.0.1+7-jre/lib/server/

echo oss
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS" --clear-logs "$@"

echo cluster 1 shard
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS" --clear-logs --env oss-cluster --shards-count 1 "$@"

echo cluster 2 shards
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS" --clear-logs --env oss-cluster --shards-count 2 "$@"

echo cluster 3 shards
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS" --clear-logs --env oss-cluster --shards-count 3 "$@"
