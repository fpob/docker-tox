#!/usr/bin/python3

import sys
import re
import requests


py_major, py_minor = map(int, sys.argv[1].split('.'))
pypy_major, pypy_minor = map(int, sys.argv[2].split('.'))
pypy_patch = None

response = requests.get('https://downloads.python.org/pypy/')
response.raise_for_status()

# Find versions in PyPy index (eg. `<a href="pypy3.7-v7.3.7-linux64.tar.bz2">`)
version_cre = re.compile(
    rf'"pypy{py_major}\.{py_minor}-v{pypy_major}\.{pypy_minor}\.(\d+)-linux64'
)
pypy_patch = max(map(int, version_cre.findall(response.text)))

print(f'{pypy_major}.{pypy_minor}.{pypy_patch}')
