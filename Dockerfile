FROM ubuntu:bionic
RUN apt-get update -qq
RUN apt-get install -q -y build-essential wget unzip maven

WORKDIR /build

ADD . /build

RUN ./deps/readies/bin/getpy3
RUN python ./system-setup.py
RUN ./deps/readies/bin/getredis --version 6

RUN make all

CMD ["redis-server", "--bind", "0.0.0.0", "--loadmodule", "./bin/RedisGears/redisgears.so", "Plugin", "./src/gears_jvm.so", "JvmOptions", "-Djava.class.path=./gears_runtime/target/gear_runtime-jar-with-dependencies.jar -Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:6380,server=y,suspend=n", "JvmPath", "./bin/OpenJDK/jdk-11.0.9.1+1/"]