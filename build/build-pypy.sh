#!/bin/bash
set -ex

PYTHON_VERSION=$1
PYPY_VERSION=$2

cd /tmp

wget -q https://downloads.python.org/pypy/pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64.tar.bz2
tar -xjf pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64.tar.bz2

mv pypy$PYTHON_VERSION-v$PYPY_VERSION-linux64 /opt/pypy$PYTHON_VERSION

# Try to reduce size...
cd /opt/pypy$PYTHON_VERSION
strip bin/* || true
find -name '*.so' -exec strip '{}' ';' || true
find -name '*.exe' -delete || true
