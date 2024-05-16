#!/bin/bash

# Note: I installed unzip and zip with
# sudo apt-get install -y zip

# recursively delete directories whose names contain "cache"
# or end with .dist-info or .egg-info. But skip any
# folders inside the ./venv/ folder since removing
# those directories break the virtual environment
rm -rf dist build
find . \
  -type d \
  \( \
    -name "*cache*" \
    -o -name "*.dist-info" \
    -o -name "*.egg-info" \
  \) \
  -not -path "./.venv/*" \
  -exec rm -r {} +

# rebuild and unzip the wheel
python -m build --sdist --wheel ./

# cd dist
# unzip *.whl
# cd ..