from time import sleep


def slow_add(a: int, b: int) -> int:
    sleep(5)
    return a + b
