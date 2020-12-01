mkdir -p ./artifacts/snapshot
tar -czvf ./artifacts/snapshot/gears-jvm.linux-$OS-x64.$GIT_BRANCH.tgz --transform "s,^./src/,./plugins/," ./bin/OpenJDK/jdk-11.0.9.1+1/* ./src/gears_jvm.so