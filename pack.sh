set -x

tar -czvf ../..//artifacts/snapshot/gears-jvm.linux-$OS-x64.$GIT_BRANCH.tgz \
--transform "s,^./src/,./plugin/," \
./bin/OpenJDK/jdk-11.0.9.1+1/* \
./src/gears_jvm.so \
./gears_runtime/target/gear_runtime-jar-with-dependencies.jar

tar -czvf ../../artifacts/release/gears-jvm.linux-$OS-x64.$VERSION.tgz \
--transform "s,^./src/,./plugin/," \
./bin/OpenJDK/jdk-11.0.9.1+1/* \
./src/gears_jvm.so \
./gears_runtime/target/gear_runtime-jar-with-dependencies.jar
