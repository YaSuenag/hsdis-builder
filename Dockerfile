FROM fedora:39
LABEL maintainer="Yasumasa Suenaga <yasuenag@gmail.com>"

RUN dnf upgrade -y && \
    dnf install -y jq zip unzip file diffutils capstone-devel autoconf gcc-c++ \
                   fontconfig-devel alsa-lib-devel cups-devel libXtst-devel \
                   libXt-devel libXrender-devel libXrandr-devel libXi-devel

ADD build-hsdis.sh .
RUN mkdir /out

ENTRYPOINT ["./build-hsdis.sh"]
