#!/usr/bin/bash

# execution flag for bash
# if any line in the script fails, the entire program will fail
set -e

# to the absolute path of the directory containing the currently executing script
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function load-dotenv {
    # adding this if condition so that this does not fail in
    # github actions CI
    if [ ! -f "$THIS_DIR/.env" ]; then
        echo "No .env file found"
        return 1
    fi

    while read -r line; do
        export "$line"
    done < <(grep -v '^#' "${THIS_DIR}/.env" | grep -v '^$')
}

function install {
    python -m pip install --upgrade pip
    python -m pip install --editable "${THIS_DIR}/[dev]"
}

function lint:ci {
    SKIP=no-commit-to-branch pre-commit run --all-files
}

function lint {
    pre-commit run --all-files
}

function test:quick {
    python -m pytest -m 'not slow' "${THIS_DIR}/tests/"
}

function test {
    # run only specified tests, if none specified, run all
    if [ $# -eq 0 ]; then
        python -m pytest "${THIS_DIR}/tests/" \
        --cov "${THIS_DIR}/packaging_demo" \
        --cov-report html
    else
        python -m pytest "$@"
    fi
}
# Example usage:
# ./run.sh test
# ./run.sh test tests/test_states_info.py::test_is_city_capital_of_state
# ./run.sh test tests/test_slow.py::test_slow_add

function build {
    python -m build --sdist --wheel "${THIS_DIR}"
}

function release:test {
    lint
    clean
    build
    publish:test
}

function release:prod {
    release:test
    publish:prod
}

# scope the publishing to test-pypi
# in bash colons are valid characters to put in identifier names
function publish:test {
    # load environment variable
    # this will not work in github CI, as we're not pushing our .env(secrets) file
    # to git, instead we're adding necessary tokens to github-secrets
    load-dotenv || true

    twine upload "${THIS_DIR}/dist/*" \
        --repository testpypi \
        --username=__token__ \
        --password="${TEST_PYPI_TOKEN}"
}

function publish:prod {
    # load environment variable
    load-dotenv || true   # this will not work in github CI

    twine upload "${THIS_DIR}/dist/*" \
        --repository pypi \
        --username=__token__ \
        --password="${PROD_PYPI_TOKEN}"
}

function clean {
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
}

function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-default}
