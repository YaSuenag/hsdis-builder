#!/bin/sh

cd /out

if [ -z "$JDK_SRC" ]; then
  JDK_SRC=http://hg.openjdk.java.net/jdk/hs/archive/tip.tar.bz2
  wget $JDK_SRC
fi

FILENAME=`basename $JDK_SRC`
MIME=`file --mime-type $FILENAME | cut -d' ' -f 2`

if [ $MIME = 'application/zip' ]; then
  unzip $FILENAME
else
  tar xvf $FILENAME
fi

cd */src/utils/hsdis
make BINUTILS=~/rpmbuild/BUILD/binutils-* ARCH=amd64
cp -f build/linux-amd64/hsdis-amd64.so /out/
