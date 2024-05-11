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

1. Configure `setup.py`
2. Run `python setup.py build sdist` to build the source distribution
3. Run `pip install ./dist/<package_name>.tar.gz` to install the package
4. Use `pip list` to see if the package is installed.

* **

1. If changes are made in the package then use `pip install .` which will build and install the latest package on the fly.

2. Or simply use editable so that you don't always have to rebuild the package evrerytime new changes are made: 
      - `pip install --editable .`