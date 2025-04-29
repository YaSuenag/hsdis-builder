FROM fedora:42
LABEL maintainer="Yasumasa Suenaga <yasuenag@gmail.com>"

RUN dnf upgrade -y && \
    dnf install -y jq zip unzip file diffutils capstone-devel capstone-static autoconf gcc-c++ \
                   fontconfig-devel alsa-lib-devel cups-devel libXtst-devel \
                   libXt-devel libXrender-devel libXrandr-devel libXi-devel awk

ADD build-hsdis.sh .
RUN mkdir /out

ENTRYPOINT ["./build-hsdis.sh"]
