#!/bin/bash
set -ex

VERSION=${1%.*}
PATCH=${1##*.}

cd /tmp

wget -q https://www.python.org/ftp/python/$VERSION.$PATCH/Python-$VERSION.$PATCH.tgz
tar -xzf Python-$VERSION.$PATCH.tgz
rm -f Python-$VERSION.$PATCH.tgz

cd Python-$VERSION.$PATCH

./configure --prefix /opt/python$VERSION
make
make install

# Try to reduce size...
cd /opt/python$VERSION
strip bin/* || true
find -name '*.so' -exec strip '{}' ';' || true
find -name '*.exe' -delete || true
