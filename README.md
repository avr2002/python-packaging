## Why package your Python code?

1. Distributing your code
2. Non-painful import statements
3. Reproduciblity


## Packaging terms:

- module
- package
- sub-package
- distribution package

> [**Official Python Packaging Guide**](https://packaging.python.org/en/latest/)



### Module

A **module** in Python is a single file (with a `.py` extension) that contains Python code. It typically consists of classes, functions, and variables that can be used by other Python code. Modules are used to organize code into logical units and facilitate code reusability.

For example, consider a module named `math_operations.py` that contains functions to perform mathematical operations like addition, subtraction, multiplication, etc. You can import and use these functions in other Python scripts.

```python
# math_operations.py

def add(x, y):
    return x + y

def subtract(x, y):
    return x - y
```

### Package

A **package** in Python is a collection of modules grouped together in a directory. A package is typically represented by a directory containing an `__init__.py` file (which can be empty) and one or more Python modules. The `__init__.py` file indicates to Python that the directory should be treated as a package.

For example, consider a package named `my_package`:

```
my_package/
├── __init__.py
├── module1.py
└── module2.py
```

Here, `my_package` is a package containing `module1.py` and `module2.py`, which can be imported using dot notation (`my_package.module1`, `my_package.module2`).

### Sub-package

A **sub-package** in Python is a package nested within another package. This means that a package can contain other packages as well as modules. Sub-packages are created by organizing directories and adding `__init__.py` files appropriately to define the package structure.

For example:

```
my_parent_package/
├── __init__.py
└── my_sub_package/
    ├── __init__.py
    ├── module3.py
    └── module4.py
```

In this structure, `my_sub_package` is a sub-package of `my_parent_package`, and it can contain its own modules (`module3.py`, `module4.py`). The sub-package can be imported using dot notation (`my_parent_package.my_sub_package.module3`).

### Distribution Package

A **distribution package** (or simply **distribution**) in Python refers to a packaged collection of Python code and resources that is made available for installation. It typically includes modules, packages, data files, configuration files, and other resources needed for a specific purpose (e.g., a library or application).

Distribution packages are often distributed and installed using Python package managers such as `pip` and can be uploaded to package repositories like PyPI (Python Package Index) for easy distribution and installation by other developers.

For example, popular distribution packages include `numpy`, `fast-api`, `pandas`, etc., which are installed using `pip` and provide functionalities that can be used in Python projects.



## Building a Distribution Package


### `sdist` format


1. Configure `setup.py`
2. Run `python setup.py build sdist` to build the source distribution
3. Run `pip install ./dist/<package_name>.tar.gz` to install the package
4. Use `pip list` to see if the package is installed.

* **

1. If changes are made in the package then use `pip install .` which will build and install the latest package on the fly.

2. Or simply use editable so that you don't always have to rebuild the package evrerytime new changes are made:
      - `pip install --editable .`


* **

- `sdist` is short for source distribution, a `.tar` file containing our code called an "sdist". What that means is that the distribution package only contains a subset of our source code.

- A "source distribution" is essentially a zipped folder containing our *source* code.

* **

### `wheel` format


#### Understanding Source Distribution (sdist) and Wheels

- **Source Distribution (`sdist`)**:
  - Represents a zipped folder containing the source code of a Python package.
  - Primarily includes Python source files (`*.py`), configuration files, and other project-related assets.
  - Provides a portable distribution format that can be used to install the package on any platform.
  - Can be created using `python setup.py sdist`.

- **Wheels (`bdist_wheel`)**:
  - A more advanced distribution format compared to `sdist`.
  - Represents a zipped file with the `.whl` extension.
  - Potentially includes more than just source code; can contain pre-compiled binaries (e.g., C extensions) for faster installation.
  - Preferred for distribution when the package includes compiled, non-Python components.
  - Created using `python setup.py bdist_wheel`.

#### Benefits of Wheels Over Source Distributions

- **Faster Installation**:
  - Installing from wheels (`*.whl`) is typically faster than installing from source distributions (`*.tar.gz`).
  - Wheels can include pre-compiled binaries, reducing the need for on-the-fly compilation during installation.
  - Most packages are “pure Python” though, so unless you are working with Python bindings such as code written in Rust, C++, C, etc. building a wheel will be just as easy as building an sdist.

- **Ease of Use for Users**:
  - Users benefit from quicker installations, especially when dealing with packages that have complex dependencies or require compilation.

#### Building Both `sdist` and `bdist_wheel`

- It's recommended to build and publish both `sdist` and `bdist_wheel` for Python packages to accommodate different use cases and platforms.
  - `python setup.py sdist bdist_wheel`
- Building both types of distributions allows users to choose the most suitable distribution format based on their needs and environment.

#### Challenges and Considerations

- **Compilation Requirements**:
  - Unfortunately, building wheels for *all* operating systems gets difficult if you have a compilation step required, so some OSS maintainers only build wheels for a single OS.

    - Whenever a wheel is not available for your OS, `pip` actually executes the [`setup.py`](http://setup.py) (or equivalent files) on *your* machine, right after downloading the sdist.

  - Building the wheel might require compiling code
    - Compiling code can be *really* slow, 5-10-30 minutes or even more, especially if the machine is weak
    - Compiling code requires dependencies, e.g. `gcc` if the source code is in C, but other languages require their own compilers. The user must install these on their on machine or the `pip install ...` will simply fail. This can happen when you install `numpy`, `pandas`, `scipy`, `pytorch`, `tensorflow`, etc.

- [`setup.py`](http://setup.py) may contain arbitrary code. This is highly insecure. A `setup.py` might contain malicious code.


- **Dependency Management**:
  - Users may need to install additional development tools and dependencies (`gcc`, etc.) to successfully install packages that require compilation.

- **Security Concerns**:
  - Using `setup.py` for package installation can be insecure as it executes arbitrary code.
  - Ensure that packages obtained from untrusted sources are reviewed and validated.


#### Naming Scheme of a `wheel` file

- A wheel filename is broken down into parts separated by hyphens:
  - `{dist}-{version}(-{build})?-{python}-{abi}-{platform}.whl`

- Each section in `{brackets}` is a tag, or a component of the wheel name that carries some meaning about what the wheel contains and where the wheel will or will not work.

- For Example: `dist/packaging-0.0.0-py3-none-any.whl`

  - `packaging` is the package name
  - `0.0.0` is the verison number
  - `py3` denotes it's build for Python3
  - `abi` tag. ABI stands for application binary interface.
  - `any` stands for that this package is build to work on any platform.

- Other Examples:
  - `cryptography-2.9.2-cp35-abi3-macosx_10_9_x86_64.whl`
  - `chardet-3.0.4-py2.py3-none-any.whl`
  - `PyYAML-5.3.1-cp38-cp38-win_amd64.whl`
  - `numpy-1.18.4-cp38-cp38-win32.whl`
  - `scipy-1.4.1-cp36-cp36m-macosx_10_6_intel.whl`

- The reason for this is, the wheel file contains the pre-complied binary code that helps to install the package fast.


#### Conclusion

- **Package Maintenance**:
  - Maintainers should strive to provide both `sdist` and `bdist_wheel` distributions to maximize compatibility and ease of use for users.

- **Consider User Experience**:
  - Consider the user's perspective when choosing the appropriate distribution format.
  - Provide clear documentation and guidance for users installing packages with compilation requirements.


## `build` CLI tool and `pyproject.toml`

- "Build dependencies" are anything that must be installed on your system in order to build your distribution package into an sdist or wheel.

    For example, we needed to `pip install wheel` in order to run `python setup.py bdist_wheel` so `wheel` is a build dependency for building wheels.

- [`setup.py`](http://setup.py) files can get complex.

    You may need to `pip install ...` external libraries and import them into your `setup.py` file to accommodate complex build processes.

    The lecture shows `pytorch` and `airflow` as examples of packages with complex [`setup.py`](http://setup.py) files.

- Somehow you need to be able to document build dependencies *outside* of [`setup.py`](http://setup.py).

    If they were documented in the `setup.py` file… you would not be able to execute the `setup.py` file to read the documented dependencies (like if they were specified in an `list` somewhere in the file).

    This is the original problem `pyproject.toml` was meant to solve.

    ```toml
    # pyproject.toml

    [build-system]
    # Minimum requirements for the build system to execute.
    requires = ["setuptools>=62.0.0", "wheel"]
    ```

    `pyproject.toml` sits adjacent to [`setup.py`](http://setup.py) in the file tree

- The `build` CLI tool (`pip install build`) is a special project by the Python Packaging Authority (PyPA) which
    1. reads the `[build-system]` table in the `pyproject.toml`,
    2. installs those dependencies into an isolated virtual environment,
    3. and then builds the sdist and wheel

    ```bash
    pip install build

    # both setup.py and pypproject.toml should be together, ideally in the root directory
    # python -m build --sdist --wheel path/to/dir/with/setup.py/and/pyproject.toml

    python -m build --sdist --wheel .
    ```


## Moving from `setup.py` to [`setup.cfg`](https://setuptools.pypa.io/en/latest/userguide/declarative_config.html) config file

>>Moving from

```python
# setup.py
from pathlib import Path

from setuptools import find_packages, setup
import wheel


# Function to read the contents of README.md
def read_file(filename: str) -> str:
    filepath = Path(__file__).resolve().parent / filename
    with open(filepath, encoding="utf-8") as file:
        return file.read()


setup(
    name="packaging-demo",
    version="0.0.0",
    packages=find_packages(),
    # package meta-data
    author="Amit Vikram Raj",
    author_email="avr13405@gmail.com",
    description="Demo for Python Packaging",
    license="MIT",
    # Set the long description from README.md
    long_description=read_file("README.md"),
    long_description_content_type="text/markdown",
    # install requires: libraries that are needed for the package to work
    install_requires=[
        "numpy",  # our package depends on numpy
    ],
    # setup requires: the libraries that are needed to setup/build
    # the package distribution
    # setup_requires=[
    #     "wheel",  # to build the binary distribution we need wheel package
    # ],
)
```

>>TO

```python
# setup.py
from setuptools import setup

# Now setup.py takes it's configurations from setup.cfg file
setup()
```

```ini
# setup.cfg

[metadata]
name = packaging-demo
version = attr: packaging_demo.VERSION
author = Amit Vikram Raj
author_email = avr13405@gmail.com
description = Demo for Python Packaging
long_description = file: README.md
keywords = one, two
license = MIT
classifiers =
    Framework :: Django
    Programming Language :: Python :: 3

[options]
zip_safe = False
include_package_data = True
# same as find_packages() in setup()
packages = find:
python_requires = >=3.8
install_requires =
    numpy
    importlib-metadata; python_version<"3.10"
```

>>ALSO addtional setting is passed to `pyproject.toml` file.
>>Here we have specified `build-system` similar to `setup_requires` in `setup.py`

```toml
# pyproject.toml

[build-system]
# Minimum requirements for the build system to execute
requires = ["setuptools", "wheel", "numpy<1.24.3"]


# Adding ruff.toml to pyproject.toml
[tool.ruff]
line-length = 99

[tool.ruff.lint]
# 1. Enable flake8-bugbear (`B`) rules, in addition to the defaults.
select = ["E", "F", "B", "ERA"]

# 2. Avoid enforcing line-length violations (`E501`)
ignore = ["E501"]

# 3. Avoid trying to fix flake8-bugbear (`B`) violations.
unfixable = ["B"]

# 4. Ignore `E402` (import violations) in all `__init__.py` files, and in select subdirectories.
[tool.ruff.lint.per-file-ignores]
"__init__.py" = ["E402"]
"**/{tests,docs,tools}/*" = ["E402"]


# copying isort configurations from .isort.cfg to pyproject.toml
[tool.isort]
profile = "black"
multi_line_output = "VERTICAL_HANGING_INDENT"
force_grid_wrap = 2
line_length = 99

# copying balck config from .black.toml to pyproject.toml
[tool.black]
line-length = 99
exclude = ".venv"

# copying flake8 config from .flake8 to pyproject.toml
[tool.flake8]
docstring-convention = "all"
extend-ignore = ["D107", "D212", "E501", "W503", "W605", "D203", "D100",
                 "E305", "E701", "DAR101", "DAR201"]
exclude = [".venv"]
max-line-length = 99

# radon
radon-max-cc = 10


# copying pylint config from .pylintrc to pyproject.toml
[tool.pylint."messages control"]
disable = [
    "line-too-long",
    "trailing-whitespace",
    "missing-function-docstring",
    "consider-using-f-string",
    "import-error",
    "too-few-public-methods",
    "redefined-outer-name",
]
```

- We have been treating [`setup.py`](http://setup.py) as a glorified config file, not really taking advantage of the fact that it is a Python file by adding logic to it.

    This is more common than not. Also, there has been a general shift away from using Python for config files because doing so adds complexity to *using* the config files (like having to install libraries in order to execute the config file).

- `setup.cfg` is a companion file to [`setup.py`](http://setup.py) that allows us to define our package configuration in a static text file—specifically an [INI format](https://en.wikipedia.org/wiki/INI_file) file.

    <aside>
    💡 INI is a problematic, weak file format compared to more “modern” formats like JSON, YAML, and *TOML*. We will prefer TOML as we move forward.

    </aside>

- Any values that we do not directly pass as arguments to setup() will be looked for by the setup() invocation in a setup.cfg file, which is meant to sit adjacent to setup.py in the file tree if used.


* **


- Now we are accumulating a lot of files!
    - `setup.py`
    - `setup.cfg`
    - `pyproject.toml`
    - `README.md`
    - More files for linting and other code quality tools, e.g. `.pylintrc`, `.flake8`, `.blackrc`, `ruff.toml`, `.mypy`, `pre-commit-config.yaml`, etc.
    - More files we have not talked about yet:
        - `CHANGELOG` or `CHANGELOG.md`
        - `VERSION` or `version.txt`

    It turns out that nearly all of these files can be replaced with `pyproject.toml` . Nearly every linting / code quality tool supports parsing a section called `[tool.<name>]` e.g. `[tool.black]` section of `pyproject.toml` to read its configuration!

    The docs of each individual tool should tell you how to accomplish this.

    Above shown is a `pyproject.toml` with configurations for many of the linting tools we have used in the course.


>**Can `setup.cfg` and `setup.py` be replaced as well?**


## [Moving `setup.cfg` to `pyproject.toml`](https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html)

>FROM `setup.cfg`
```ini
# setup.cfg
[metadata]
name = packaging-demo
version = attr: packaging_demo.VERSION
author = Amit Vikram Raj
author_email = avr13405@gmail.com
description = Demo for Python Packaging
long_description = file: README.md
keywords = one, two
license = MIT
classifiers =
    Programming Language :: Python :: 3

[options]
zip_safe = False
include_package_data = True
# same as find_packages() in setup()
packages = find:
python_requires = >=3.8
install_requires =
    numpy
    importlib-metadata; python_version<"3.10"
```

>TO

```toml
# pyproject.toml

[build-system]
# Minimum requirements for the build system to execute
requires = ["setuptools>=61.0.0", "wheel"]

# Adding these from setup.cfg in pyproject.toml file
[project]
name = "packaging-demo"
authors = [{ name = "Amit Vikram Raj", email = "avr13405@gmail.com" }]
description = "Demo for Python Packaging"
readme = "README.md"
requires-python = ">=3.8"
keywords = ["one", "two"]
license = { text = "MIT" }
classifiers = ["Programming Language :: Python :: 3"]
dependencies = ["numpy", 'importlib-metadata; python_version<"3.10"']
# dynamic = ["version"]
version = "0.0.0"
```

>> `python -m build --sdist --wheel .` - Runs perfectly, we got rid of another config file (`setup.cfg`)


## Replacing `setup.py` with `build-backend`


- [PEP 517](https://peps.python.org/pep-0517/) added a `build-backend` argument to `pyproject.toml` like so:

    ```toml
    [build-system]
    # Defined by PEP 518:
    requires = ["flit"]
    # Defined by this PEP:
    build-backend = "flit.api:main"
    ```

    ```python
    # The above toml config is equivalent to
    import flit.api
    backend = flit.api.main
    ```

- The `build-backend` defines an entrypoint (executable Python module in this case) that the `build` CLI uses to actually do the work of parsing `pyproject.toml` and building the wheel and sdist.

- This means *you* could implement your own build backend today by writing a program that does that, and you could use it by adding your package to `requires = [...]` and specifying the entrypoint in `build-backend = ...`.


- If you do not specify a `build-backend` in `pyproject.toml`, setuptools is assumed and package will get bulit prefectly fine.
  - If we remove `setup.py` and run `python -m build --sdist --wheel .` it runs perfectly without it because the default value of `build-system` is set as `build-backend = "setuptools.build_meta"` in `build` CLI which builds our package.

- But you can still explicitly declare `setuptools` as your build backend like this

    ```toml
    # pyproject.toml

    ...

    [build-system]
    requires = ["setuptools>=61.0.0", "wheel"]
    build-backend = "setuptools.build_meta"

    ...
    ```

    Each build backend typically extends the `pyproject.toml` file with its own configuration options. For example,

    ```toml
    # pyproject.toml

    ...

    [tool.setuptools.package-data]
    package_demo = ["*.json"]

    [tool.setuptools.dynamic]
    version = {file = "version.txt"}
    long_description = {file = "README.md"}

    ...
    ```

- If you choose to use `setuptools` in your project, you can add these sections to `pyproject.toml`. You can read more about this in the `setuptools` documentation


## Adding Data Files in our Package

- It's often beneficial to include non-python files like data files or binary files inside of your package because oftentimes your Python code relies on these non-python files.

- And then we saw that if we're going to include those files, we need to get those files to end up inside of our package folder because it's our package folder that ends up inside of our users virtual environments upon installation.

- We also saw that by default, all non-python files don't make it into that final virtual environment folder. That is, don't actually make it into our package folder during build procedure.

So, how do we make sure that these files end up in our wheel/dist build of our package? For example here we demo with `cities.json` file that we want in our package as it's used by `states_info.py` file.

>[**Official `setuptools` Docs for Data Support**](https://setuptools.pypa.io/en/latest/userguide/datafiles.html)

### Using [MANIFEST.in](https://setuptools.pypa.io/en/latest/userguide/miscellaneous.html#using-manifest-in) File


```toml
# pyprject.toml

[tool.setuptools]
# ...
# By default, include-package-data is true in pyproject.toml, so you do
# NOT have to specify this line.
include-package-data = true
```

So, setuptools by default has this `include-package-data` value set to `true` as shown in the [official docs](https://setuptools.pypa.io/en/latest/userguide/datafiles.html) but we need to create an extra file `MANIFEST.in` and specify the data which we want to inculde in our package present at root dir.

>>**IMP:** It's import all the folders in the package directory should have `__init__.py` file inculing the data directory which we want to include because the `find_packages()` recusrive process that setuptools does will not go into fo;ders that have `__init__.py` file in it.

```in
#  MANIFEST.in

include packaging_demo/*.json
include packaging_demo/my_folder/*.json

OR
Recursive include all json files in the package directory

recursive-include packaging_demo/ *.json
```

>[Docs on configuring MANIFEST.in file](https://setuptools.pypa.io/en/latest/userguide/miscellaneous.html#using-manifest-in)

### Without using `MANIFEST.in` file

From [setuptools docs](https://setuptools.pypa.io/en/latest/userguide/datafiles.html) we can add this in our `pyproject.toml` file:

```toml
# this is by default true so no need to explicitly add it
# but as mentioned in the docs, it is false for other methods like setup.py or setup.cfg
[tool.setuptools]
include-package-data = true

# add the data here, it's finding the files recursively
[tool.setuptools.package-data]
package_demo = ["*.json"]
```


## Other `build-backend` systems than `setuptools`

Other than `setuptools` we can use these build backend systems. The point to note is when using other systems the `pyproject.toml` cofiguration should follow their standerds.

1. [Hatch](https://hatch.pypa.io/1.9/config/build)

    ```toml
    [build-system]
    requires = ["hatchling"]
    build-backend = "hatchling.build"
    ```
2. [Poetry](https://python-poetry.org/docs/pyproject/)

    ```toml
    [build-system]
    requires = ["poetry-core>=1.0.0"]
    build-backend = "poetry.core.masonry.api"
    ```

## Reproducibility, Dependency Graph, Locking Dependencies, Dependency Hell

- Documenting the exact versions of our dependencies and their dependencies and so on.

- It's advisable to have as little as possible number of dependencies associated with our package, as it can lead to dependency hell, or dependency conflict with other package as explained in the lectures.

- The more complex the dependency tree higher the chance of conflicts with future version of other libraries.

- [Dependency Graph Analysis By Eric](https://github.com/avr2002/dependency-graph-pip-analysis)

- Keeping the pinned versions of dependencies and python versions is advicable for troubleshooting purposes:
  - `pip freeze > requirements.txt`


```bash
pip install pipdeptree graphviz

sudo apt-get install graphviz  

# generate the dependency graph
pipdeptree -p packaging-demo --graph-output png > dependency-graph.png
```

<a href='https://raw.githubusercontent.com/avr2002/python-packaging/main/packaging_demo/assets/dependency-graph.png' target='_blank'>
    <img src='https://raw.githubusercontent.com/avr2002/python-packaging/main/packaging_demo/assets/dependency-graph.png' alt='Dependency Graph of packaging-demo package' title='Dependency Graph of packaging-demo package'>
</a>

* **

## Adding Optional/Extra Dependencies to our Project

```toml
[project.optional-dependencies]
dev = ["ruff", "mypy", "black"]
```

```bash
# installing our package with optional dependencies
pip install '.[dev]'
```

* **

```toml
[project.optional-dependencies]
# for developement
dev = ["ruff", "mypy", "black"]
# plugin based architecture
colors = ["rich"]
```

```bash
# plugin based installation
pip install '.[colors]'
# here we demo with rich library, if user wants the output to be
# colorized then they can install our package like this.


# we can add multiple optional dependencies like:
pip install '.[colors, dev]'
```

* **

```toml
[project.optional-dependencies]
# for developement
dev = ["ruff", "mypy", "black"]
# plugin based architecture
colors = ["rich"]
# install all dependencies
all = ["packaging-demo[dev, colors]"]
```

```bash
# Installing all dependencies all at once
pip install '.[all]'
```


## Shopping for dependencies

We can use [Snyk](https://snyk.io/advisor/python/fastapi) to check how stable, well supported, if any security issues, etc. are present for the dependencies which we are going to use for our package and then take the decision on using it in our project.

* **

# Continuous Delivery: Publishing to PyPI

- Few key terms realted to Continuous Delivery
  - DevOps, Waterfall, Agile, Scrum


### Publishing to PyPI

To pusblish our package to PyPI[Python Packaging Index], as stated in the [official guide](https://packaging.python.org/en/latest/), we use [`twine` CLI tool](https://twine.readthedocs.io/en/latest/).

```bash
pip install twine

twine upload --help
```

1. Generate API Token for [PyPI Test](https://test.pypi.org/) or [PyPI Prod](https://pypi.org/)

2. Build your python package: `python -m build --sdist --wheel "${PACKAGE_DIR}"`, here we're building both sdist and wheel, as recommended.

3. Run the twine tool: `twine upload --repository testpypi ./dist/*`, uplading to test-pypi


### Task Runner

- `CMake` and `Makefile`

  - `sudo apt-get install make`


- [Taskfile](https://github.com/adriancooney/Taskfile)


- [`justfile`](https://github.com/casey/just)
- [pyinvoke](https://www.pyinvoke.org/)
