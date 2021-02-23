FROM debian:stable-slim

ARG DEFAULT_PYTHON
ARG DEFAULT_PYPY

RUN apt-get update \
    && apt-get install --no-install-recommends -yV \
        libbz2-1.0 \
        libc6 \
        libffi6 \
        libgdbm6 \
        liblzma5 \
        libncurses5 \
        libncursesw5 \
        libpq5 \
        libreadline7 \
        libsqlite3-0 \
        libssl1.1 \
        openssl \
        tk \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY opt /opt

RUN for i in $(ls -1 /opt) ; do ln -sfv /opt/$i/bin/$i /usr/local/bin/$i ; done

ENV PATH=/opt/python$DEFAULT_PYTHON/bin:/opt/pypy$DEFAULT_PYPY/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN python3 -m ensurepip && pip3 install -U pip \
    && pip3 install setuptools wheel tox

WORKDIR /workdir
CMD ["tox"]
