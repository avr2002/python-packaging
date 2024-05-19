import pytest

from packaging_demo.states_info import is_city_capital_of_state


# multiple tests in one
@pytest.mark.parametrize(
    argnames="city_name, state, is_capital",
    argvalues=[
        ("Ranchi", "Jharkhand", True),
        ("Patna", "Bihar", True),
        ("Bangalore", "Karnataka", True),
        ("Mumbai", "Maharashtra", True),
        ("Patna", "Jharkhand", False),
    ],
)
def test_is_city_capital_of_state(city_name: str, state: str, is_capital: bool):
    assert is_city_capital_of_state(city_name=city_name, state=state) == is_capital


# def test_is_city_capital_of_state_correct():
#     assert is_city_capital_of_state(city_name="Ranchi", state="Jharkhand")    # noqa:ERA001

# def test_is_city_capital_of_state_false():
#     assert not is_city_capital_of_state(city_name="Patna", state="Jharkhand") # noqa:ERA001
