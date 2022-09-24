#!/bin/bash
set -o errexit -o nounset -o pipefail

VERSION=$1
VERSION_FULL=$(
    curl -s https://www.python.org/ftp/python/ \
        | grep -Po "${VERSION//./\\.}\.\d+" \
        | sort -uV | tail -n1
)

if [[ -z "${VERSION_FULL}" ]] ; then
    echo "Failed to find latest PyPy ${VERSION} version!" >&2
    exit 1
fi

cd /tmp

wget -q https://www.python.org/ftp/python/${VERSION_FULL}/Python-${VERSION_FULL}.tgz
tar -xzf Python-${VERSION_FULL}.tgz
rm -f Python-${VERSION_FULL}.tgz

cd Python-${VERSION_FULL}

./configure --prefix=/opt/python${VERSION} --with-ensurepip=no
make -j $(nproc)
make install

set +o errexit
find /opt/python${VERSION} -type f \( -name '*.so' -o -path '*/bin/*' \) -exec strip '{}' +
find /opt/python${VERSION} -type d \( -name '__pycache__' -o -name 'test' -o -name 'tests' \) -exec rm -rf '{}' +
find /opt/python${VERSION} -type f \( -name '*.exe' -o -name '*.py[co]' \) -exec rm -rf '{}' +
