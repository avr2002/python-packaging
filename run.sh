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
    # save the exit status of test
    PYTEST_EXIT_STATUS=0

    python -m pytest -m 'not slow' "${THIS_DIR}/tests/" \
        --cov "$THIS_DIR/packaging_demo" \
        --cov-report html \
        --cov-report term \
        --cov-report xml \
        --junit-xml "$THIS_DIR/test-reports/report.xml" \
        --cov-fail-under 60 || ((PYTEST_EXIT_STATUS+=$?))

    mv coverage.xml "$THIS_DIR/test-reports/"
    mv htmlcov "$THIS_DIR/test-reports/"
    mv .coverage "$THIS_DIR/test-reports/"

    return $PYTEST_EXIT_STATUS
}

function test {
    PYTEST_EXIT_STATUS=0
    # run only specified tests, if none specified, run all

    # if [ $# -eq 0 ]; then
    #     python -m pytest "${THIS_DIR}/tests/" \
    #     --cov "${THIS_DIR}/packaging_demo" \
    #     --cov-report html
    # else
    #     python -m pytest "$@"
    # fi

    # same as above
    python -m pytest "${@:-$THIS_DIR/tests/}" \
        --cov "$THIS_DIR/packaging_demo" \
        --cov-report html \
        --cov-report term \
        --cov-report xml \
        --junit-xml "$THIS_DIR/test-reports/report.xml" \
        --cov-fail-under 60 || ((PYTEST_EXIT_STATUS+=$?))

    mv coverage.xml "$THIS_DIR/test-reports/"
    mv htmlcov "$THIS_DIR/test-reports/"
    mv .coverage "$THIS_DIR/test-reports/"

    return $PYTEST_EXIT_STATUS
}
# Example usage for test function:
# ./run.sh test
# Use :: to select a single test
# ./run.sh test tests/test_states_info.py::test_is_city_capital_of_state
# ./run.sh test tests/test_slow.py::test_slow_add


function serve-coverage-report {
    python -m http.server --directory "$THIS_DIR/htmlcov/"
}

function test:wheel-locally {
    # deactivate current virtual env(.venv)
    source deactivate || true
    # clean up existing test-venv if available
    rm -rf test-env || true

    # create a new test virtual env & activate it
    python -m venv test-env
    source test-env/bin/activate

    # clean any cache files if available
    clean || true

    # install build CLI and build the package
    pip install build
    build
    # install the package wheel and test dependencies
    pip install ./dist/*.whl pytest pytest-cov

    # run tests on wheel
    test:ci

    # clear up test virtual env
    source deactivate
    rm -rf test-env
    clean

    # lastly activate your main virtual environment
    source .venv/bin/activate
}


function test:ci {
    PYTEST_EXIT_STATUS=0
    INSTALLED_PKG_DIR="$(python -c 'import packaging_demo; print(packaging_demo.__path__[0])')"
    python -m pytest "${@:-$THIS_DIR/tests/}" \
        --cov "$INSTALLED_PKG_DIR" \
        --cov-report html \
        --cov-report term \
        --cov-report xml \
        --junit-xml "$THIS_DIR/test-reports/report.xml" \
        --cov-fail-under 60 || ((PYTEST_EXIT_STATUS+=$?))

    mv coverage.xml "$THIS_DIR/test-reports/"
    mv htmlcov "$THIS_DIR/test-reports/"
    mv .coverage "$THIS_DIR/test-reports/"

    return $PYTEST_EXIT_STATUS
}

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
    rm -rf dist build coverage.xml test-reports
    find . \
    -type d \
    \( \
        -name "*cache*" \
        -o -name "*.dist-info" \
        -o -name "*.egg-info" \
        -o -name "*htmlcov" \
    \) \
    -not -path "./*env/*" \
    -exec rm -r {} +
}

function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-default}
