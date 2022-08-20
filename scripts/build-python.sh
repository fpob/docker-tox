#!/bin/bash
set -eux

VERSION=$1
VERSION_FULL=$(/scripts/find-python-version.py $VERSION)

cd /tmp

wget -q https://www.python.org/ftp/python/$VERSION_FULL/Python-$VERSION_FULL.tgz
tar -xzf Python-$VERSION_FULL.tgz
rm -f Python-$VERSION_FULL.tgz

cd Python-$VERSION_FULL

./configure --prefix /opt/python$VERSION
make
make install

/scripts/cleanup.sh /opt/python$VERSION
