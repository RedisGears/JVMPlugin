DIST?=$(shell ./deps/readies/bin/platform --dist)
DIST_VERSION?=$(shell ./deps/readies/bin/platform --version)
OS?=$(shell uname -s)
ARCH?=$(shell uname -m)
OSNICK?=$(shell ./deps/readies/bin/platform --osnick)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
VERSION=$(shell ./getver)

$(info OS=$(OS))

all: gears_jvm GearsRuntime

.PHONY: InstallOpenJDK

gears_jvm: InstallOpenJDK
	make -C ./src/

/tmp/openjdk-hotspot.zip:
	test -f /tmp/opendjk-hotspot.zip || wget "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9.1%2B1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.9.1_1.tar.gz" -O /tmp/openjdk-hotspot.zip

InstallOpenJDK: bin/OpenJDK

bin/OpenJDK: /tmp/openjdk-hotspot.zip
	test -d ./bin/OpenJDK || mkdir -p ./bin/OpenJDK
	tar -C ./bin/OpenJDK -xvf /tmp/openjdk-hotspot.zip

GearsRuntime:
	cd gears_runtime; mvn package

clean:
	make -C ./src/ clean

tests: gears_jvm
	cd ./pytest; ./run_test.sh ${PYTHONDIR}

run: gears_jvm
	cp ../../redisgears.so ../../gears_python.so .
	redis-server --loadmodule ./redisgears.so Plugin ./src/gears_jvm.so JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar" JvmPath ./bin/OpenJDK/jdk-11.0.9.1+1/

run_valgrind:
	cp ../../redisgears.so ../../gears_python.so .
	valgrind --leak-check=full --log-file=output.val redis-server --loadmodule ./redisgears.so Plugin ./src/gears_jvm.so JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar" JvmPath ./bin/OpenJDK/jdk-11.0.9.1+1/

pack: gears_jvm
	OS=$(OSNICK) GIT_BRANCH=$(GIT_BRANCH) VERSION=$(VERSION) ./pack.sh
