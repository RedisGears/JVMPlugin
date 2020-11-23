OPEN_J9_DIR=$(abspath ../bin/OpenJDK/jdk-11.0.9.1+1)
OPEN_J9_BUILD_DIR=$(OPEN_J9_DIR)

ifeq ($(DEBUG),1)
	GCC_FLAGS=-o0 -g -DVALGRIND -fno-omit-frame-pointer
else
	GCC_FLAGS=-o2
endif

SOURCES=gears_jvm.c utils/adlist.c
HEADERS=jni.h jni_md.h jvm_memory.h redisgears.h redismodule.h version.h utils/adlist.h utils/arr.h utils/arr_rm_alloc.h

ARTIFACT_NAME=gears_jvm.so

all: $(ARTIFACT_NAME)

$(ARTIFACT_NAME): $(HEADERS) $(SOURCES)
	gcc -std=gnu99 $(GCC_FLAGS) $(SOURCES) -shared -fpic -DREDISMODULE_EXPERIMENTAL_API \
	-Wl,--disable-new-dtags -Wl,-rpath=$(OPEN_J9_BUILD_DIR)/lib/server \
	-L$(OPEN_J9_BUILD_DIR)/lib/server \
	-ljvm \
	-o $(ARTIFACT_NAME)

clean:
	rm $(ARTIFACT_NAME)