#!/usr/bin/python3

import sys
import re
import requests


major, minor = map(int, sys.argv[1].split('.'))
patch = None

response = requests.get('https://www.python.org/ftp/python/')
response.raise_for_status()

# Find versions in Nginx index (eg. `<a href="3.10.0/">3.10.0/</a>`)
version_cre = re.compile(rf'"{major}\.{minor}\.(\d+)/"')
patch = max(map(int, version_cre.findall(response.text)))

print(f'{major}.{minor}.{patch}')
