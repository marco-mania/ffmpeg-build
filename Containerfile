FROM docker.io/debian:trixie as build

RUN set -ex \
    && sed -i -- 's/Types: deb/Types: deb deb-src/g' /etc/apt/sources.list.d/debian.sources \
    && apt update \
    && apt install -y --no-install-recommends \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    gperf \
    cmake \
    meson \
    sudo \
    git \
    yq \
    wget \
    ca-certificates \
    libexpat-dev \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && useradd -ms /bin/bash builder \
    && chown -R builder:builder /home/builder \
    && update-ca-certificates

ENV TARGET_DIR="/usr/local"
ENV YAML_DEPS_FILE="/etc/ffmpeg-build-deps.yaml"

COPY sudoers /etc/sudoers
COPY ffmpeg-build /usr/local/bin
COPY ffmpeg-build-deps.yaml /etc

USER builder
WORKDIR /home/builder


FROM docker.io/debian:trixie-slim as release

RUN set -ex \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY ffmpeg_root/. /usr/local/

RUN ldconfig

CMD ["--help"]
ENTRYPOINT ["/usr/local/bin/ffmpeg"]
