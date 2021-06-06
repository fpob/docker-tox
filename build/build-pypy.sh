#!/bin/bash
set -ex

PYTHON_VERSION=$1
PYPY_VERSION=$2

cd /tmp

wget -q https://downloads.python.org/pypy/pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64.tar.bz2
tar -xjf pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64.tar.bz2

mv pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64 /opt/pypy$PYTHON_VERSION

# Starting with PyPy 7.3.5, tarball contains python* binaries - remove them to
# avoid conflicts with CPython.
rm -f /opt/pypy$PYTHON_VERSION/bin/python*

/cleanup.sh /opt/pypy$PYTHON_VERSION
