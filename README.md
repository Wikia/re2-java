re2-java
========
re2-java library is a dependency of Phalanx service. It provides Java bindings for [Google's RE2 library](https://github.com/google/re2), written in C++. See https://github.com/Wikia/re2-java/blob/master/README_VENDOR.md for original docs.

## Building ##
Requirements:
* JDK 7
* maven
* GCC 4.8
* Boost C++ library
If you are building Phalanx service, building re2-java should not be necessary, because it is fetched from maven. If you need to rebuild re2-java, simply run:

	$ JAVA_HOME=/path/to/jvm/root make
