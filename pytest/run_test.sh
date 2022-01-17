#!/bin/bash
set -x
set -e

if [ -z $1 ]; then
    echo "No path to top-level binaries specified"
    exit 3
fi

mkdir -p ./gears_tests/build/;cd ./gears_tests/build/;../../../bin/OpenJDK/jdk-11.0.9.1+1/bin/javac -d ./ -classpath ./../../../gears_runtime/target/gear_runtime-jar-with-dependencies.jar ../src/gears_tests/*;../../../bin/OpenJDK/jdk-11.0.9.1+1/bin/jar -cvf gears_tests.jar ./gears_tests/
cd ../../

JVM_OPTIONS="-Djava.class.path="
JVM_OPTIONS+="../../gears_runtime/target/gear_runtime-jar-with-dependencies.jar"
#JVM_OPTIONS+=" -XX:+IdleTuningGcOnIdle";
#JVM_OPTIONS+=" -Xms10m";
#JVM_OPTIONS+=" -Xmx2048m";
#JVM_OPTIONS+=" -Xrs";
#JVM_OPTIONS+=" -Xcheck:jni";

#echo $JVM_OPTIONS
#JVM_PATH=../../../../deps/openj9-openjdk-jdk14/build/linux-x86_64-server-release/jdk/lib/server/
JVM_PATH=../../bin/OpenJDK/jdk-11.0.9.1+1/

GEARSPYTHON=../gears_python.so
GEARSJVM=../src/gears_jvm.so
PYENVDIR=$1
shift

echo oss
python3 -m RLTest --module ../redisgears.so --module-args "Plugin ${GEARSJVM} JvmPath $JVM_PATH JvmOptions $JVM_OPTIONS Plugin ${GEARSPYTHON} CreateVenv 0 PythonInstallationDir ${PYTHONDIR}" --clear-logs "$@"

echo cluster 1 shard
python3 -m RLTest --module ../redisgears.so --module-args "Plugin ${GEARSJVM} JvmPath $JVM_PATH JvmOptions $JVM_OPTIONS Plugin ${GEARSPTHON} CreateVenv 0 PythonInstallationDir ${PYTHONDIR}" --clear-logs --env oss-cluster --shards-count 1 "$@"

echo cluster 2 shards
python3 -m RLTest --module ../redisgears.so --module-args "Plugin ${GEARSJVM} JvmPath $JVM_PATH JvmOptions $JVM_OPTIONS Plugin ${GEARSPYTHON} CreateVenv 0 PythonInstallationDir ${PYTHONDIR}" --clear-logs --env oss-cluster --shards-count 2 "$@"

echo cluster 3 shards
python3 -m RLTest --module ../redisgears.so --module-args "Plugin ${GEARSJVM} JvmPath $JVM_PATH JvmOptions $JVM_OPTIONS Plugin ${GEARSPYTHON} CreateVenv 0 PythonInstallationDir ${PYTHONDIR}" --clear-logs --env oss-cluster --shards-count 3 "$@"

rm -rf ../bin/RedisGears/.venv-*
