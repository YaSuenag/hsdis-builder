hsdis-builder
===
![Container ready](../../actions/workflows/publish-container.yaml/badge.svg)

Docker container for building [HSDIS](https://github.com/openjdk/jdk/tree/master/src/utils/hsdis). This container can build HSDIS powered by [Capstone](https://www.capstone-engine.org/) for Linux x64/aarch64 in JDK 25 or later.

Base image of this container is Fedora 42. Thus HSDIS which the artifact of this container might not work on older glibc.

## Pull image

See [GitHub Container Registry](https://github.com/YaSuenag/hsdis-builder/pkgs/container/hsdis-builder)

```
$ podman pull ghcr.io/yasuenag/hsdis-builder
```

## Build HSDIS (Run container)

You can get the artifact (HSDIS) from `out` in following example.

### Build HSDIS from upstream

```
podman run -it --rm -v /path/to/outdir:/out:Z ghcr.io/yasuenag/hsdis-builder
```

Link Capstone statically

```
podman run -it --rm -v /path/to/outdir:/out:Z ghcr.io/yasuenag/hsdis-builder -static
```

### Build HSDIS from specified version

> [!NOTE]
> JDK 25 will be released in September 2025 - meanwhile you need to use upstream OpenJDK code.

You need to specify tag in https://github.com/openjdk/jdk

```
podman run -it --rm -v /path/to/outdir:/out:Z ghcr.io/yasuenag/hsdis-builder jdk-25-ga
```

Link Capstone statically

```
podman run -it --rm -v /path/to/outdir:/out:Z ghcr.io/yasuenag/hsdis-builder -static jdk-25-ga
```

## Deploy HSDIS

### JDK 8 or earlier

```sh
$ cp hsdis-amd64.so $JAVA_HOME/jre/lib/amd64/
```

### JDK 9 or later

```sh
$ cp hsdis-amd64.so $JAVA_HOME/lib/
```

## Build container image

```sh
$ buildah bud --layers -t hsdis-builder .
```
