OS=$(shell ./deps/readies/bin/platform --osnick)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
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
	redis-server --loadmodule ./bin/RedisGears/redisgears.so Plugin ./src/gears_jvm.so JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar" JvmPath ./bin/OpenJDK/jdk-11.0.9.1+1/ CreateVenv 1 pythonInstallationDir ./bin/RedisGears/
	
pack: gears_jvm
	OS=$(OS) GIT_BRANCH=$(GIT_BRANCH) ./pack.sh
