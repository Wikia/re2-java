#
# Inspired by https://github.com/xerial/snappy-java/blob/develop/Makefile .
#

OBJ=obj
MVN=mvn

ifeq ($(OS),Windows_NT)
    OS_NAME := Windows
    OS_ARCH := "x86_64"
else
	OS_NAME := $(shell bin/os-name.sh)
	OS_ARCH := $(shell uname -m)
endif

NATIVES-TARGET="src/main/resources/NATIVE/$(OS_ARCH)/$(OS_NAME)"

ifeq ($(OS_NAME),Darwin)
	LIB_EXT := dylib
	CPP_OPTS := -lre2
	LINKER_OPTS := -shared -Wl,-install_name,libre2-java.so
else
	LIB_EXT := so
	CPP_OPTS := -l:libre2.so
	LINKER_OPTS := -shared -Wl,-soname,libre2-java.so
endif

all: build
build: $(OBJ)/libre2-java.so class

.re2.download.stamp:
	git submodule update --init
	touch .re2.download.stamp

.re2.compile.stamp: .re2.download.stamp
	cd re2 && make
	touch .re2.compile.stamp

$(OBJ)/RE2.o: .re2.download.stamp $(addprefix src/main/java/com/logentries/re2/, RE2.cpp RE2.h)
	mkdir -p $(OBJ)
	$(CXX) -O3 -g -std=c++11 -fPIC -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/$(OS_NAME) -Ire2 -Iassert/include -c src/main/java/com/logentries/re2/RE2.cpp -o $(OBJ)/RE2.o

$(OBJ)/libre2-java.so: $(OBJ)/RE2.o .re2.compile.stamp
	$(CXX) $(LINKER_OPTS) -o $(OBJ)/libre2-java.so $(OBJ)/RE2.o -Lre2/obj/so $(CPP_OPTS) -lpthread

class: build-class

build-class: target/libre2-java-1.0-SNAPSHOT.jar

target/libre2-java-1.0-SNAPSHOT.jar: add-so
	$(MVN) package -Dmaven.test.skip=true

add-so: .re2.compile.stamp $(OBJ)/libre2-java.so
	mkdir -p $(NATIVES-TARGET)
	cp $(OBJ)/libre2-java.so re2/obj/so/libre2.$(LIB_EXT) $(NATIVES-TARGET)

clean:
	rm -fr obj
	rm -fr target
	rm -fr src/main/resources/NATIVE
	rm -f .*.stamp
