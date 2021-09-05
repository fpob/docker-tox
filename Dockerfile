FROM debian:bullseye-slim

ARG DEFAULT_PYTHON
ARG DEFAULT_PYPY

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

COPY opt /opt

RUN for i in $(ls -1 /opt) ; do ln -sfv /opt/$i/bin/$i /usr/local/bin/$i ; done

ENV PATH=/opt/python$DEFAULT_PYTHON/bin:/opt/pypy$DEFAULT_PYPY/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN python3 -m ensurepip \
    && pip3 --no-cache-dir install -U pip \
    && pip3 --no-cache-dir install setuptools wheel tox \
    && find /opt -name '__pycache__' -exec rm -rf '{}' +

WORKDIR /workdir
CMD ["tox"]
