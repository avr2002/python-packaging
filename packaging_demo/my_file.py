import numpy as np

from packaging_demo.my_folder import A
from packaging_demo.my_folder.my_nested_file import CONSTANT as CONSTANT2
from packaging_demo.my_other_file import CONSTANT

MY_ARRAY = np.array([[1, 2], [2, 1]])
print(MY_ARRAY)

print(CONSTANT)
print(CONSTANT2)
print(A)
