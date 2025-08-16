defmodule AboutAsserts do
  @moduledoc """
  We shall contemplate truth by testing reality, via asserts.

  ## Understanding Assertions

  Assertions are the foundation of testing in any language. They verify that your
  code behaves as expected by checking conditions and failing when those conditions
  are not met.

  In Elixir, assertions help us verify:
  - Boolean conditions (true/false)
  - Equality between values
  - Pattern matching success
  - Exception handling

  ## The Philosophy of Testing

  Testing is not just about finding bugs - it's about documenting behavior,
  providing examples of usage, and ensuring your code continues to work as
  requirements evolve.
  """

  import Enlightenment

  # Tests are named to run in pedagogical order (alphabetical execution)
  # Each test builds on concepts from previous tests

  def test_01_assert_truth do
    # CONCEPT: Basic Boolean Assertions
    #
    # The `assert` macro checks if an expression is "truthy" (not false or nil).
    # In Elixir, everything except `false` and `nil` is considered truthy.
    #
    # Examples of truthy values: true, 1, "hello", [], %{}, :ok
    # Examples of falsy values: false, nil

    assert Enlightenment.__()
  end

  def test_02_assert_with_message do
    # CONCEPT: Descriptive Test Names and Self-Documenting Code
    #
    # Good tests serve as documentation. The test name should clearly describe
    # what behavior is being verified. Comments should explain the concept
    # being tested, not just repeat what the code does.

    assert Enlightenment.__()
  end

  def test_03_assert_equality do
    # CONCEPT: Testing Expected vs Actual Values
    #
    # When testing, it's important to separate what you expect to happen
    # from what actually happens. This makes tests clearer and helps
    # identify bugs when expectations don't match reality.

    expected_value = 2
    actual_value = 1 + 1

    assert_equal(Enlightenment.__(), actual_value)

    # The order matters: assert_equal(expected, actual)
    # This convention helps readers understand what the test is checking
  end

  def test_04_pattern_matching_equality do
    # CONCEPT: Pattern Matching as Assertion
    #
    # Elixir's pattern matching provides an elegant way to assert equality.
    # The `^` (pin) operator prevents rebinding and enforces equality check.
    # This is more idiomatic Elixir than traditional assert_equal.

    expected_value = 2
    actual_value = 1 + 1

    # Pattern matching with pin operator: like assert_equal but more Elixir-like
    ^expected_value = Enlightenment.__()

    # This would fail if actual_value wasn't equal to expected_value:
    # ^expected_value = 3  # MatchError!

    # Pattern matching is powerful for complex data structures:
    # {:ok, result} = some_function()  # Asserts success and extracts result
    # [head | tail] = [1, 2, 3]       # Asserts non-empty list and extracts parts
  end

  def test_05_fill_in_values do
    # CONCEPT: Hands-on Learning Through Koans
    #
    # In traditional koans, you fill in blanks (represented by __ or __())
    # to make tests pass. This active participation helps cement learning
    # by requiring you to think about and predict the results.

    assert_equal(Enlightenment.__(), 1 + 1)

    # Other examples you might see:
    # assert_equal(__, "hello" <> " world")  # String concatenation
    # assert_equal(__, [1, 2, 3] |> length()) # List length using pipe operator
  end

  def test_06_understanding_assertion_failures do
    # CONCEPT: Learning from Failures
    #
    # When assertions fail, they provide valuable information about what
    # went wrong. Understanding error messages is crucial for debugging.

    # Uncomment these to see different types of assertion failures:

    # assert false
    # # Would show: "Expected false to be truthy"

    # assert_equal(3, 1 + 1)
    # # Would show: "Expected 3, but got 2"

    # 3 = 1 + 1
    # # Would show: MatchError - no match of right hand side value: 2

    # Understanding these error messages helps you debug real code!
    assert Enlightenment.__()
  end

  def test_07_multiple_assertions do
    # CONCEPT: Testing Multiple Related Conditions
    #
    # Sometimes one test needs to verify several related conditions.
    # Each assertion should check a specific aspect of the behavior.

    result = 1 + 1

    # We can make multiple assertions about the same result
    # Check the value
    assert_equal(Enlightenment.__(), result)
    # Check the type
    assert is_integer(result)
    # Check it's positive
    assert result > 0
    # Check it's reasonable
    assert result < 10

    # Each assertion verifies a different aspect of the computation
  end

  def test_08_assertions_with_complex_data do
    # CONCEPT: Testing Complex Data Structures
    #
    # Real applications work with complex data like maps, lists, and tuples.
    # Assertions help verify the structure and content of this data.

    user_data = %{name: "Alice", age: 30, active: true}

    # Test the structure exists
    assert is_map(user_data)

    # Test specific values using pattern matching
    %{name: name, age: age, active: active} = user_data
    assert_equal(Enlightenment.__(), name)
    assert_equal(Enlightenment.__(), age)
    assert_equal(Enlightenment.__(), active)

    # Alternative: test individual fields
    assert_equal("Alice", user_data.name)
    assert user_data.age > 0
    assert user_data.active
  end
end
