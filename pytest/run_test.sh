#!/bin/bash
set -x

mkdir -p ./gears_tests/build/;cd ./gears_tests/build/;../../../bin/OpenJDK/jdk-11.0.9.1+1/bin/javac -d ./ -classpath ./../../../gears_runtime/target/gear_runtime-0.0.3-SNAPSHOT-jar-with-dependencies.jar ../src/gears_tests/*;../../../bin/OpenJDK/jdk-11.0.9.1+1/bin/jar -cvf gears_tests.jar ./gears_tests/
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
JVM_PATH=../bin/OpenJDK/jdk-11.0.9.1+1/lib/server/

echo oss
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../bin/RedisGears/redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS CreateVenv 1 pythonInstallationDir ../../bin/RedisGears/" --clear-logs "$@"

echo cluster 1 shard
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../bin/RedisGears/redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS CreateVenv 1 pythonInstallationDir ../../bin/RedisGears/" --clear-logs --env oss-cluster --shards-count 1 "$@"

echo cluster 2 shards
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../bin/RedisGears/redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS CreateVenv 1 pythonInstallationDir ../../bin/RedisGears/" --clear-logs --env oss-cluster --shards-count 2 "$@"

echo cluster 3 shards
LD_LIBRARY_PATH=$JVM_PATH python2.7 -m RLTest --module ../bin/RedisGears/redisgears.so --module-args "PluginsDirectory ../../src/ JvmOptions $JVM_OPTIONS CreateVenv 1 pythonInstallationDir ../../bin/RedisGears/" --clear-logs --env oss-cluster --shards-count 3 "$@"

rm -rf ../bin/RedisGears/.venv-*
