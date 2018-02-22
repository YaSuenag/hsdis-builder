FROM fedora:26
LABEL maintainer "Yasumasa Suenaga <yasuenag@gmail.com>"

RUN dnf upgrade -y \
  && dnf install -y gcc-c++ rpm-build unzip dnf-plugins-core perl-podlators bc \
                    bison dejagnu flex gettext glibc-static libstdc++-static \
                    m4 sharutils texinfo zlib-devel zlib-static wget
RUN dnf download --source binutils \
  && rpm -ivh binutils-* \
  && rpmbuild -bp ~/rpmbuild/SPECS/binutils.spec

ADD build-hsdis.sh .

ENTRYPOINT ["./build-hsdis.sh"]

