#!/bin/sh

ARG1=$1
ARG2=$2

if [ -z "$ARG1" ]; then
  IS_STATIC=0
  JDKVER=""
elif [ "$ARG1" = "-static" ]; then
  IS_STATIC=1
  JDKVER="$ARG2"
elif [ "${ARG1:0:1}" != '-' ]; then
  IS_STATIC=0
  JDKVER="$ARG1"
else
  echo "Unknow option: $ARG1"
  exit 100
fi

mkdir builder
cd builder

if [ -z "$JDKVER" ]; then
  JDK_SRC_LINK=https://github.com/openjdk/jdk/archive/refs/heads/master.tar.gz
  BOOT_JDK_VER=`curl -sSL https://api.adoptium.net/v3/info/available_releases | jq -r .most_recent_feature_release` || exit 1
else
  JDK_SRC_LINK=https://github.com/openjdk/jdk/archive/refs/tags/$JDKVER.tar.gz
  JDK_RELEASE_VER=`echo $JDKVER | tr +- , | cut -d , -f 2`
  if [ $JDK_RELEASE_VER -lt 25 ]; then
    echo 'hsdis-builder supports JDK 25 or later.'
    exit 1
  fi
  BOOT_JDK_VER=`expr $JDK_RELEASE_VER - 1`
fi

echo 'Download and extract JDK source'
curl -sSL $JDK_SRC_LINK | tar xvz || exit 2
pushd jdk* > /dev/null
JDK_SRC=`pwd`
popd > /dev/null
echo

# Determine CPU architecture
ARCH=`uname -m`
if [ "$ARCH" == x86_64 ]; then
  ARCH=x64
fi
echo "CPU architecture: $ARCH"
echo

echo 'Retrieve boot JDK'
BOOT_JDK_LINK=`curl -sSL "https://api.adoptium.net/v3/assets/latest/$BOOT_JDK_VER/hotspot?architecture=$ARCH&image_type=jdk&os=linux&vendor=eclipse" | jq -r '.[0].binary.package.link' || exit 3`
curl -sSL "$BOOT_JDK_LINK" | tar xvz || exit 4
pushd jdk-$BOOT_JDK_VER** > /dev/null
export JAVA_HOME=`pwd`
popd > /dev/null
echo


# Allow HSDIS for Linux building on WSL
IS_WSL=`uname -r | grep -i microsoft > /dev/null`
if [ $? -eq 0 ]; then
  CONFIGURE_OPTS="$CONFIGURE_OPTS --build=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu"
fi


echo 'Run configure script'
cd $JDK_SRC
bash configure --with-hsdis=capstone


# Override spec.gmk to use static library if needs
if [ $IS_STATIC -eq 1 ]; then
  sed -i 's|^HSDIS_LIBS :=.\+$|HSDIS_LIBS := /usr/lib64/libcapstone.a|' build/linux-*/spec.gmk
fi


echo 'Build HSDIS'
make build-hsdis && \
  cp build/linux-*/support/hsdis/hsdis-*.so /out/
