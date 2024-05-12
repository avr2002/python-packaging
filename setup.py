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
