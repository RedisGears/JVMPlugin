set -e
tar -czf ../../artifacts/snapshot/redisgears-jvm.Linux-$OS-x86_64.$GIT_BRANCH.tgz \
--transform "s,^./src/,./plugin/," \
./bin/OpenJDK/jdk-11.0.9.1+1/* \
./src/gears_jvm.so \
./gears_runtime/target/gear_runtime-jar-with-dependencies.jar
sha256sum ../../artifacts/snapshot/redisgears-jvm.Linux-$OS-x86_64.$GIT_BRANCH.tgz > ../../artifacts/snapshot/redisgears-jvm.Linux-$OS-x86_64.$GIT_BRANCH.tgz.sha256

tar -czf ../../artifacts/release/redisgears-jvm.Linux-$OS-x86_64.$VERSION.tgz \
--transform "s,^./src/,./plugin/," \
./bin/OpenJDK/jdk-11.0.9.1+1/* \
./src/gears_jvm.so \
./gears_runtime/target/gear_runtime-jar-with-dependencies.jar
sha256sum ../../artifacts/release/redisgears-jvm.Linux-$OS-x86_64.$VERSION.tgz > ../../artifacts/release/redisgears-jvm.Linux-$OS-x86_64.$VERSION.tgz.sha256
