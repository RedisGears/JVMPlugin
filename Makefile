OS=$(shell ./deps/readies/bin/platform --osnick)
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
	redis-server --loadmodule ./bin/RedisGears/redisgears.so PluginsDirectory ./src/ JvmOptions "-Djava.class.path=./gears_runtime/target/gear_runtime-0.0.3-SNAPSHOT-jar-with-dependencies.jar" CreateVenv 1 pythonInstallationDir ./bin/RedisGears/
	
