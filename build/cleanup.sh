#!/usr/bin/env bash

# Try to reduce size...
find "$1" -type f \( -name '*.so' -o -path '*/bin/*' \) -exec strip '{}' +
find "$1" -type d \( -name '__pycache__' -o -name 'test' -o -name 'tests' \) -exec rm -rf '{}' +
find "$1" -type f \( -name '*.exe' -o -name '*.py[co]' \) -exec rm -rf '{}' +
