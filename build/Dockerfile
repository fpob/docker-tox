FROM debian:stable

# Add deb-src to sources.list
RUN find /etc/apt/sources.list* -type f -exec sed -i 'p; s/^deb /deb-src /' '{}' +

RUN apt-get update \
    && apt-get install -yV \
        ca-certificates \
        curl \
        wget \
        build-essential \
        openssl \
        libssl-dev \
        libncursesw5-dev \
        libc6-dev \
        libpq-dev \
        libffi-dev \
        libbz2-dev \
        libgdbm-dev \
        libsqlite3-dev \
        libreadline6-dev \
        libncurses5-dev \
        zlib1g-dev \
        liblzma-dev \
        tk-dev \
    && apt-get build-dep -y python3 \
    && apt-get clean

COPY ["build-python.sh", "build-pypy.sh", "cleanup.sh", "/"]
RUN chmod +x /build-python.sh /build-pypy.sh /cleanup.sh
