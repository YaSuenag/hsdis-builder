# hsdis-builder

Docker container for building [hsdis](http://hg.openjdk.java.net/jdk/jdk/file/tip/src/utils/hsdis/README). This container can build hsdis for Linux x64 in JDK 10 or later.

Base image of this container is Fedora 26. Thus hsdis which the artifact of this container might not work on older glibc.

## Build image

```
$ docker build . -t yasuenag/hsdis-builder
```

## Pull image

See [Docker Hub repository](https://hub.docker.com/r/yasuenag/hsdis-builder/)

```
$ docker pull yasuenag/hsdis-builder
```

## Build hsdis (Run container)

```
$ docker run -it --rm --privileged -v /path/to/outdir:/out yasuenag/hsdis-builder
```

Download JDK source from http://hg.openjdk.java.net/jdk/hs/archive/tip.tar.bz2 , and build hsdis.
You can get `hsdis-amd64.so` from `/path/to/outdir`.

If you have OpenJDK source archive from http://hg.openjdk.java.net/ , you can pass it to `JDK_SRC` and can avoid download phase.
This container supports tar.bz2, tar.gz, and zip. You need to deploy it to `/path/to/outdir`.

```
$ docker run -it --rm --privileged -v /path/to/outdir:/out -e JDK_SRC=<source archive> yasuenag/hsdis-builder
```

## Deploy hsdis

```
$ cp hsdis-amd64.so $JAVA_HOME/jre/lib/amd64/
```

## Notes

hsdis cannot be built with binutils 2.29 or later due to [refactoring of binutils](https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commit;f=include/dis-asm.h;h=003ca0fd22863aaf1a9811c8a35a0133a2d27fb1). So I choose Fedora 26 for base image.
This problem will be fixed in [JDK-8191006](https://bugs.openjdk.java.net/browse/JDK-8191006).

