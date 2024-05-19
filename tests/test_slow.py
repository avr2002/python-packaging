import pytest

from packaging_demo.slow import slow_add


# using pytest markers to mark slowly running tests as 'slow'
# objective: to run the time consuming later and get done with
# other tests as soon as possible
@pytest.mark.slow
def test_slow_add():
    sum_ = slow_add(1, 2)
    assert sum_ == 3


# Example usage:
# pytest tests -m 'not slow' # run tests that are not marked 'slow'
# pytest tests -m 'slow' # opposite of above
