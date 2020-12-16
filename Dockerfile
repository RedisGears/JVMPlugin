FROM ubuntu:bionic
RUN apt update
RUN apt install -y build-essential wget unzip maven

WORKDIR /build

ADD . /build

RUN ./deps/readies/bin/getpy2

RUN ./deps/readies/bin/getredis --version 6

RUN make all

CMD ["redis-server", "--bind", "0.0.0.0", "--loadmodule", "./bin/RedisGears/redisgears.so", "Plugin", "./src/gears_jvm.so", "JvmOptions", "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar", "JvmPath", "./bin/OpenJDK/jdk-11.0.9.1+1/", "CreateVenv", "1", "pythonInstallationDir", "./bin/RedisGears/"]