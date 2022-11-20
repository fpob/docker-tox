FROM docker.io/library/debian:bullseye AS builder

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
        python3 \
    && apt-get build-dep -y python3

COPY scripts /scripts

# When updating versions, it is also necessary to update 'tests/tox.ini' file
# and `DEFAULT_*` variables below.
RUN /scripts/build-python.sh '3.7'
RUN /scripts/build-python.sh '3.8'
RUN /scripts/build-python.sh '3.9'
RUN /scripts/build-python.sh '3.10'
RUN /scripts/build-python.sh '3.11'
RUN /scripts/build-pypy.sh '3.7' '7.3'
RUN /scripts/build-pypy.sh '3.8' '7.3'
RUN /scripts/build-pypy.sh '3.9' '7.3'


FROM docker.io/library/debian:bullseye-slim

ARG DEFAULT_PYTHON=3.11
ARG DEFAULT_PYPY=3.9

RUN apt-get update \
    && apt-get install --no-install-recommends -yV \
        gcc \
        make \
        libc-dev \
        libbz2-1.0 \
        libc6 \
        libffi7 \
        libgdbm6 \
        liblzma5 \
        libncurses5 \
        libncursesw5 \
        libpq5 \
        libreadline8 \
        libsqlite3-0 \
        libssl1.1 \
        openssl \
        tk \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt /opt

RUN for i in $(ls -1 /opt) ; do ln -sfv /opt/$i/bin/$i /usr/local/bin/$i ; done

ENV PATH="/opt/python${DEFAULT_PYTHON}/bin:/opt/pypy${DEFAULT_PYPY}/bin:${PATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN python3 -m ensurepip && pip3 --no-cache-dir install setuptools wheel tox

CMD ["tox"]
