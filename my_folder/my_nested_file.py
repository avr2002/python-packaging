# import sys

# sys.path.insert(0, "/home/avr27/repos")

# By doing sys.path.insert, you can directly run python
# my_folder/my_nested_file.py without doing PYTHONPATH

# print(sys.path)

# PYTHONPATH=$PYTHONPATH:/home/avr27/repos/my_folder python my_folder/my_nested_file.py # noqa: E501
# from my_other_file import CONSTANT as CONST

# $ PYTHONPATH=$PYTHONPATH:/home/avr27/repos python my_folder/my_nested_file.py
from packaging.my_other_file import CONSTANT as CONST

CONSTANT = "HELLO"

print(CONST)
