
JVM_PATH=./bin/OpenJDK/jdk-11.0.9.1+1/
GEARS_PATH=./bin/RedisGears/redisgears.so
JVM_PLUGIN_PATH=./src/gears_jvm.so
JVM_PLUGIN_CLASSPATH=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar

all: gears_jvm

gears_jvm: InstallRedisGears InstallOpenJDK GearsRuntime
	make -C src
	
InstallRedisGears:
	./Install_RedisGears.sh
	
InstallOpenJDK:
	./Install_OpenJDK.sh
	
GearsRuntime:  
	cd gears_runtime; mvn package

clean:
	make -C src clean
	
tests: gears_jvm
	cd pytest; ./run_test.sh

run: gears_jvm
	redis-server --loadmodule $(GEARS_PATH) Plugin $(JVM_PLUGIN_PATH) JvmOptions "-Djava.class.path=$(JVM_PLUGIN_CLASSPATH)" JvmPath $(JVM_PATH)
	
pack: gears_jvm
	./pack.sh
