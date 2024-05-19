## Testing

- **Tests should be black box as much as possible:**
  - When optimizing/changing the code implementation that produces the same
    output as before, the test cases for that function should not get affected by
    this change. This what we mean by **balck box**.

  - Tests that are not inline with above, are called **brittle tests**.

- **Test Case Universe**
  - The universe is the set of all possible test cases or all possible inputs
    that we could run through a function in testing.

  - But there are many tests for which it is infeasible to think/write all the
    possible test cases.

- **Unit Test**
  - A unit test is a type of test that tests one very specific thing or set differently.
    It tests a single unit of your code base that could be a single unit of your app's
    functionality, or it could be a single unit of code, like literally a single
    function or a single class.

  - **Why unit test?**
    - The behind idea that is if your test is only testing one thing and then that test
      suddenly fails to run, you have a pretty good idea of what caused that test to fail.

    - Whereas if you have a complex test that's running 20 different functions that you wrote,
      and then the test fails, you don't know which of those 20 functions failed or if some
      interaction between those functions caused them to fail.

  - The convention is that for each piece/unit of code we write a test specific to that unit.

  - So, a good way to organize our tests would be to have a parallel folder structure that
    mirrors what our packages folder file structure, in our test folder too.
