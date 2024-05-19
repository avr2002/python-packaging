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