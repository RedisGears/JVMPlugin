OPEN_J9_DIR=/var/opt/redislabs/modules/rg/999999/deps/jdk-14.0.1+7-jre
OPEN_J9_BUILD_DIR=$(OPEN_J9_DIR)

ifeq ($(DEBUG),1)
	GCC_FLAGS=-o0 -g -DVALGRIND -fno-omit-frame-pointer
else
	GCC_FLAGS=-o2
endif

all:
	gcc $(GCC_FLAGS) gears_jvm.c utils/adlist.c -shared -fpic -DREDISMODULE_EXPERIMENTAL_API \
	-Wl,--disable-new-dtags -Wl,-rpath=/var/opt/redislabs/modules/rg/999999/deps/jdk-14.0.1+7-jre/lib/server/ \
	-L$(OPEN_J9_BUILD_DIR)/lib/server \
	-ljvm \
	-o gears_jvm.so
