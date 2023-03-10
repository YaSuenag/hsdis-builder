#!/bin/sh

JDKVER=$1

mkdir builder
cd builder

if [ -z "$JDKVER" ]; then
  JDK_SRC_LINK=https://github.com/openjdk/jdk/archive/refs/heads/master.tar.gz
  BOOT_JDK_VER=`curl -s https://api.adoptium.net/v3/info/available_releases | jq -r .most_recent_feature_release`
else
  JDK_SRC_LINK=https://github.com/openjdk/jdk/archive/refs/tags/$JDKVER.tar.gz
  JDK_RELEASE_VER=`echo $JDKVER | tr +- , | cut -d , -f 2`
  if [ $JDK_RELEASE_VER -lt 19 ]; then
    echo 'hsdis-builder supports JDK 19 or later.'
    exit 1
  fi
  BOOT_JDK_VER=`expr $JDK_RELEASE_VER - 1`
fi

echo 'Download and extract JDK source'
curl -sL $JDK_SRC_LINK | tar xvz
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
BOOT_JDK_LINK=`curl -s "https://api.adoptium.net/v3/assets/latest/$BOOT_JDK_VER/hotspot?architecture=$ARCH&image_type=jdk&os=linux&vendor=eclipse" | jq -r '.[0].binary.package.link'`
curl -sL "$BOOT_JDK_LINK" | tar xvz
pushd jdk-$BOOT_JDK_VER** > /dev/null
export JAVA_HOME=`pwd`
popd > /dev/null
echo

echo 'Build HSDIS'
cd $JDK_SRC
bash configure --with-hsdis=capstone
make build-hsdis
cp build/linux-*/support/hsdis/hsdis-*.so /out/
