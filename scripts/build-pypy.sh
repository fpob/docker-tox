#!/bin/bash
set -o errexit -o nounset -o pipefail

PYTHON_VERSION=$1
PYPY_VERSION=$2
PYPY_VERSION_FULL=$(
    curl -s --compressed https://downloads.python.org/pypy/ \
        | grep -Po "pypy${PYTHON_VERSION//./\\.}-v${PYPY_VERSION//./\\.}\.\d+" \
        | sort -uV | tail -n1
)

if [[ -z "${PYPY_VERSION_FULL}" ]] ; then
    echo "Failed to find latest PyPy ${PYTHON_VERSION} ${PYPY_VERSION} version!" >&2
    exit 1
fi

cd /tmp

wget -q https://downloads.python.org/pypy/${PYPY_VERSION_FULL}-linux64.tar.bz2
tar -xjf ${PYPY_VERSION_FULL}-linux64.tar.bz2

mv ${PYPY_VERSION_FULL}-linux64 /opt/pypy${PYTHON_VERSION}

# Starting with PyPy 7.3.5, tarball contains python* binaries - remove them to
# avoid conflicts with CPython.
rm -f /opt/pypy${PYTHON_VERSION}/bin/python*

set +o errexit
find /opt/pypy${PYTHON_VERSION} -type f \( -name '*.so' -o -path '*/bin/*' \) -exec strip '{}' +
find /opt/pypy${PYTHON_VERSION} -type d \( -name '__pycache__' -o -name 'test' -o -name 'tests' \) -exec rm -rf '{}' +
find /opt/pypy${PYTHON_VERSION} -type f \( -name '*.exe' -o -name '*.py[co]' \) -exec rm -rf '{}' +
