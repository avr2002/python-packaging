## `$PYTHONPATH` and Nested Imports


### `PYTHONPATH` Variable

- `PATH` variable in Bash Terminal

  ```bash
  echo $PATH
  ```

  - This will give you a colon seperated list of directories, one of them being location to
    python executable, which you can verify using below command too

    ```bash
    which python
    where python # for windows
    ```

- Now if we were to type a python command in our terminal, our bash/zshell would loop over from
  start to finish this colon separated list and the first folder where it found an executable
  program named Python.

- In essense this is how imports work in bash, when you type A command, this is sort of an import process
  by which the executable or we could call it a module in Python terms is discovered and then loaded
  in or in this case, executed, like below:

  ```python
  python my_folder/some_python_file.py
  ```

- **Python uses something similar to discover importable modules. Python has a variable called the `PYTHONPATH` variable, which is also a list of folders(like `PATH` in bash) where Python looks for modules when you do these import statements.**

-  What is `PYTHONPATH`?

   - `PYTHONPATH` is an environment variable which you can set to add additional directories that Python should add to the list of paths to look for modules and packages.

   - The directories specified in `PYTHONPATH` are appended to the default list of directories Python searches for modules, which includes the standard library and site-packages.


### The Problem

Directory Structure:

```bash
.
├── my_file.py
├── my_folder
│   ├── README.md
│   ├── __init__.py
│   └── my_nested_file.py
└── my_other_file.py
```


```python
# my_folder/my_nested_file.py
from packaging.my_other_file import CONSTANT as CONST

CONSTANT = "HELLO"

print(CONST)
```

The issue we are addressing involves the inability to import modules correctly when running a Python script (`my_nested_file.py`) located in a nested directory (`my_folder`) relative to a custom module directory (`/home/avr27/repos`).

When attempting to execute the script using `python my_folder/my_nested_file.py`, Python encounters a `ModuleNotFoundError` because it cannot locate the desired module (`packaging.my_other_file`) within the specified path (`/home/avr27/repos`).

```bash
$ python my_folder/my_nested_file.py  
Traceback (most recent call last):
  File "/home/avr27/repos/packaging/my_folder/my_nested_file.py", line 1, in <module>
    from packaging.my_other_file import CONSTANT as CONST
ModuleNotFoundError: No module named 'packaging'
```

This error occurs because Python's module search path (`sys.path`) does not include the directory `/home/avr27/repos`, which contains the necessary modules (`packaging.my_other_file`) for the script to function correctly.

To resolve this issue, we explore methods to dynamically modify `sys.path` within the script itself (`my_nested_file.py`) or set the `PYTHONPATH` environment variable to include the required directory (`/home/avr27/repos`). These approaches aim to ensure that Python can locate and import modules from custom paths, allowing for successful execution of the script without encountering import errors.

* **

To import modules from a directory one level above the current directory in Python and understand the usage of the `PYTHONPATH` variable, you can follow these steps.

### 1. Using `sys.path.insert` for Local Imports

In your Python script (`my_folder/my_nested_file.py`), you can use `sys.path.insert` to modify the import path dynamically:

```python
# my_folder/my_nested_file.py

import sys
sys.path.insert(0, '/home/avr27/repos')

# Now, you can directly run this script without setting PYTHONPATH explicitly.
from packaging.my_other_file import CONSTANT as CONST

CONSTANT = "HELLO"

print(CONST)
```

This code snippet inserts `/home/avr27/repos` at the beginning of the Python path (`sys.path`), allowing you to import modules from that directory directly.

Here, `packaging` refers to the directory `/home/avr27/repos`, and `my_other_file` is a module within that directory.

### 2. Setting PYTHONPATH Environment Variable in terminal

Alternatively, you can set the `PYTHONPATH` environment variable to include the desired directory:

```bash
$ PYTHONPATH=$PYTHONPATH:/home/avr27/repos python my_folder/my_nested_file.py
```

This command sets the `PYTHONPATH` to include `/home/avr27/repos`, enabling you to import modules from this path in your Python script like:

```python
# my_folder/my_nested_file.py

from packaging.my_other_file import CONSTANT as CONST

CONSTANT = "HELLO"

print(CONST)
```

>>OR

```bash
$ PYTHONPATH=$PYTHONPATH:/home/avr27/repos/my_folder python my_folder/my_nested_file.py
```

```python
# my_folder/my_nested_file.py

from my_other_file import CONSTANT as CONST

CONSTANT = "HELLO"

print(CONST)
```

### Summary

By understanding and applying these concepts, you can effectively manage module imports from custom directories and avoid the need to manually modify `PYTHONPATH` every time you run your script.


>**NOTE:** *This is just a hacky way and not the standard way of doing things and should be avoided, rather we create a python package.*
