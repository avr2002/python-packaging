## Packaging terms:

- module
- package
- sub-package
- distribution package



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

