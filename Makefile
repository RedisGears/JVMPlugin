OS?=$(shell ./deps/readies/bin/platform --osnick)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
VERSION=$(shell ./getver)
$(info OS=$(OS))

ifdef WITH_GEARS
all: InstallRedisGears gears_jvm
else
all: gears_jvm
endif

.PHONY: InstallOpenJDK

gears_jvm: InstallOpenJDK GearsRuntime
	make -C ./src/

InstallRedisGears:
	OS=$(OS) /bin/bash ./Install_RedisGears.sh

/tmp/openjdk-hotspot.zip:
	test -f /tmp/opendjk-hotspot.zip || wget "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9.1%2B1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.9.1_1.tar.gz" -O /tmp/openjdk-hotspot.zip

InstallOpenJDK: bin/OpenJDK

bin/OpenJDK: /tmp/openjdk-hotspot.zip
	test -d ./bin/OpenJDK || mkdir -p ./bin/OpenJDK
	tar -C ./bin/OpenJDK -xvf /tmp/openjdk-hotspot.zip

GearsRuntime: InstallOpenJDK
	cd gears_runtime; mvn package

clean:
	make -C ./src/ clean

tests: gears_jvm
	cd ./pytest; ./run_test.sh

run: gears_jvm
	redis-server --loadmodule ./bin/RedisGears/redisgears.so Plugin ./src/gears_jvm.so JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar" JvmPath ./bin/OpenJDK/jdk-11.0.9.1+1/

run_valgrind:
	valgrind --leak-check=full --log-file=output.val redis-server --loadmodule ./bin/RedisGears/redisgears.so Plugin ./src/gears_jvm.so JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar" JvmPath ./bin/OpenJDK/jdk-11.0.9.1+1/

pack: gears_jvm
	OS=$(OS) GIT_BRANCH=$(GIT_BRANCH) VERSION=$(VERSION) ./pack.sh
