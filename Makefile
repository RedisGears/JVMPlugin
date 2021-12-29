GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
VERSION=$(shell ./getver)

_OS=$(shell ./deps/readies/bin/platform --osnick)
ifeq ($(_OS),centos8)
	OS=rhel8
else
ifeq ($(_OS),centos7)
	OS=rhel7
else
	OS=$(_OS)
endif
endif
$(info OS=$(OS))

all: gears_jvm

gears_jvm: InstallRedisGears InstallOpenJDK GearsRuntime
	make -C ./src/

InstallRedisGears:
	OS=$(OS) /bin/bash ./Install_RedisGears.sh

InstallOpenJDK:
	/bin/bash ./Install_OpenJDK.sh

GearsRuntime:
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
