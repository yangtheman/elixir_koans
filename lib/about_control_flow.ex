defmodule AboutControlFlow do
  @moduledoc """
  Elixir provides several control flow constructs.
  Unlike imperative languages, everything in Elixir returns a value.

  ## Understanding Control Flow in Elixir

  Control flow in Elixir is fundamentally different from imperative languages.
  Every expression returns a value, making the language more functional and
  composable. There are no statements - only expressions that evaluate to values.

  ## Key Principles

  **Everything returns a value:**
  - `if/else` returns the value of the executed branch
  - `case` returns the value of the matched clause
  - `cond` returns the value of the first true condition
  - `with` returns the value of the do block or the non-matching value

  **Pattern matching is central:**
  - Most control flow uses pattern matching for dispatch
  - Guards extend patterns with boolean conditions
  - Failure to match can be handled explicitly

  **Immutable by design:**
  - Control flow doesn't change variables, it produces new values
  - No side effects in conditional logic
  - Functional composition over sequential execution

  ## Control Flow Constructs

  **Conditional:**
  - `if/unless` - Simple boolean conditions
  - `cond` - Multiple condition testing
  - `case` - Pattern matching with guards

  **Iteration:**
  - `for` comprehensions - Transform and filter data
  - Recursion - Primary iteration mechanism
  - `Enum` functions - Higher-order iteration

  **Error handling:**
  - `with` - Chain operations that might fail
  - `try/rescue/catch/after` - Exception handling
  - Tagged tuples - Explicit success/failure

  **Advanced:**
  - `receive` - Message handling in processes
  - Function clauses - Multiple function definitions
  - Guards - Boolean conditions in patterns

  ## Functional vs Imperative

  **Traditional imperative:**
  ```
  result = null
  if (condition) {
    result = doSomething()
  } else {
    result = doSomethingElse()
  }
  ```

  **Elixir functional:**
  ```elixir
  result = if condition, do: do_something(), else: do_something_else()
  ```

  This functional approach eliminates whole classes of bugs and makes
  code more predictable and testable.
  """

  import Enlightenment

  def test_01_if_else do
    # CONCEPT: Conditional Expressions Return Values
    #
    # Unlike many languages where if/else are statements, Elixir's if/else
    # are expressions that always return a value. This makes them composable
    # and eliminates the need for temporary variables in many cases.

    # if/else always returns a value
    result1 = if true, do: "yes", else: "no"
    result2 = if false, do: "yes", else: "no"

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    # if/else characteristics:
    # - Always returns a value (never void/undefined)
    # - Can be used anywhere an expression is expected
    # - Branches must return compatible types or the result is dynamic
    # - Condition uses truthiness (nil and false are falsy)
    #
    # Functional patterns:
    # message = if user.admin?, do: "Welcome admin", else: "Welcome user"
    # status_code = if success?, do: 200, else: 500
    # redirect = if authenticated?, do: dashboard_path(), else: login_path()
    #
    # This eliminates common imperative patterns:
    # message = nil  # No need for this!
    # if user.admin? do
    #   message = "Welcome admin"
    # else
    #   message = "Welcome user"
    # end
  end

  def test_02_if_without_else do
    # CONCEPT: Default Return Values
    #
    # When if has no else clause, it returns nil if the condition is false.
    # This is useful for optional side effects or when nil is a meaningful
    # "no result" value in your application logic.

    # if without else returns nil when condition is false
    result1 = if true, do: "something"
    result2 = if false, do: "something"

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    # When to use if without else:
    #
    # Optional side effects:
    # if debug_mode?, do: IO.puts("Debug info")
    #
    # Optional value assignment:
    # error_msg = if errors, do: "Please fix errors"
    #
    # Guard-like conditions:
    # if authorized?, do: perform_action()
    #
    # Pattern with || for defaults:
    # result = (if condition, do: value) || default_value
    #
    # Note: Consider using && for side effects:
    # debug_mode? && IO.puts("Debug info")  # More idiomatic
  end

  def test_03_unless do
    # CONCEPT: Negative Conditional Logic
    #
    # unless is syntactic sugar for if with negated condition.
    # It improves readability when you're testing for negative conditions
    # and makes code more expressive and intention-revealing.

    # unless is the opposite of if
    result1 = unless false, do: "yes", else: "no"
    result2 = unless true, do: "yes", else: "no"

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    # unless vs if comparison:
    # unless condition, do: action  # More readable
    # if not condition, do: action  # Less readable
    #
    # Good unless usage:
    # unless user.banned?, do: allow_access()
    # unless Enum.empty?(items), do: process_items()
    # unless errors, do: save_record()
    #
    # Avoid complex unless conditions:
    # unless x > 5 and y < 10, do: action  # Hard to read
    # if x <= 5 or y >= 10, do: action    # Better
    #
    # unless is best for simple negative conditions where the
    # positive phrasing would be awkward or less clear
  end

  def test_04_cond do
    # CONCEPT: Multiple Condition Testing
    #
    # cond is like a switch/case statement but for boolean conditions rather
    # than pattern matching. It evaluates conditions sequentially and executes
    # the first truthy condition, making it perfect for complex decision trees.

    # cond allows multiple conditions
    x = 10

    result =
      cond do
        x < 5 -> "small"
        x < 15 -> "medium"
        x < 100 -> "large"
        # default case
        true -> "huge"
      end

    assert_equal(Enlightenment.__(), result)

    # cond characteristics:
    # - Evaluates conditions top-to-bottom
    # - Returns value of first truthy condition's clause
    # - Raises CondClauseError if no condition matches
    # - Common to use 'true' as catch-all final condition
    #
    # cond vs if/else chains:
    #
    # Instead of nested if/else:
    # if score >= 90 do
    #   "A"
    # else
    #   if score >= 80 do
    #     "B"
    #   else
    #     if score >= 70 do
    #       "C"
    #     else
    #       "F"
    #     end
    #   end
    # end
    #
    # Use cond:
    # cond do
    #   score >= 90 -> "A"
    #   score >= 80 -> "B"
    #   score >= 70 -> "C"
    #   true -> "F"
    # end
  end

  def test_05_case_with_literals do
    # CONCEPT: Pattern Matching for Control Flow
    #
    # case is Elixir's primary pattern matching construct for control flow.
    # Unlike switch statements in other languages, case uses pattern matching
    # rather than just equality, making it incredibly powerful and flexible.

    value = :ok

    result =
      case value do
        :ok -> "success"
        :error -> "failure"
        _ -> "unknown"
      end

    assert_equal(Enlightenment.__(), result)

    # case pattern matching power:
    # - Matches structure, not just equality
    # - Destructures data in the match
    # - Guards can add boolean conditions
    # - Exhaustiveness checking helps prevent bugs
    #
    # Pattern types in case:
    #
    # Literal matching:
    # :ok, "hello", 42, true
    #
    # Variable binding:
    # x -> "got #{x}"
    #
    # Wildcard:
    # _ -> "matches anything"
    #
    # Structure matching:
    # {:ok, result} -> "success with #{result}"
    # [head | tail] -> "list starting with #{head}"
    # %{name: name} -> "user named #{name}"
  end

  def test_06_case_with_pattern_matching do
    # CONCEPT: Destructuring with Pattern Matching
    #
    # case really shines when matching complex data structures. You can
    # destructure tuples, lists, maps, and other structures while simultaneously
    # testing their shape and extracting values.

    response = {:ok, "data", 200}

    result =
      case response do
        {:ok, data, 200} -> "Success: #{data}"
        {:ok, data, code} -> "OK with code #{code}: #{data}"
        {:error, reason} -> "Error: #{reason}"
        _ -> "Unknown response"
      end

    assert_equal(Enlightenment.__(), result)

    # Advanced pattern matching examples:
    #
    # HTTP responses:
    # case response do
    #   {200, headers, body} -> process_success(body)
    #   {404, _, _} -> handle_not_found()
    #   {status, _, _} when status >= 400 -> handle_error(status)
    # end
    #
    # List processing:
    # case list do
    #   [] -> "empty"
    #   [single] -> "one item: #{single}"
    #   [first, second] -> "two items: #{first}, #{second}"
    #   [head | tail] -> "starts with #{head}, has #{length(tail)} more"
    # end
    #
    # Map destructuring:
    # case user do
    #   %{role: :admin, active: true} -> grant_admin_access()
    #   %{role: :user, active: true} -> grant_user_access()
    #   %{active: false} -> deny_access("inactive")
    #   _ -> deny_access("unknown role")
    # end
  end

  def test_07_case_with_guards do
    # CONCEPT: Guards Extend Pattern Matching
    #
    # Guards add boolean conditions to patterns, allowing you to create
    # more specific matches. They're restricted to safe, side-effect-free
    # expressions to maintain pattern matching reliability.

    number = 15

    result =
      case number do
        x when x < 0 -> "negative"
        x when x == 0 -> "zero"
        x when x > 0 and x < 10 -> "small positive"
        x when x >= 10 -> "large positive"
      end

    assert_equal(Enlightenment.__(), result)

    # Guard capabilities and restrictions:
    #
    # Allowed in guards:
    # - Comparison operators: ==, !=, >, <, >=, <=, ===, !==
    # - Boolean operators: and, or, not (strict versions only)
    # - Arithmetic: +, -, *, /, rem, div, abs
    # - Type checks: is_atom, is_binary, is_list, is_map, etc.
    # - Built-in functions: length, size, node, etc.
    #
    # Not allowed in guards:
    # - Custom functions (unless specifically whitelisted)
    # - Anonymous functions
    # - Side-effect operations
    # - Variables from outside scope (except parameters)
    #
    # Real-world guard examples:
    # case user_input do
    #   x when is_binary(x) and byte_size(x) > 0 -> process_string(x)
    #   x when is_integer(x) and x > 0 -> process_positive_int(x)
    #   x when is_list(x) and length(x) > 0 -> process_list(x)
    #   _ -> handle_invalid_input()
    # end
  end

  def test_08_with_statement_success do
    # CONCEPT: Chaining Operations That Might Fail
    #
    # with is Elixir's elegant solution for chaining operations that return
    # success/failure tuples. It eliminates nested case statements and makes
    # happy path logic linear and readable while handling errors gracefully.

    # with allows chaining operations that might fail
    user_data = %{name: "Alice", email: "alice@example.com"}

    result =
      with {:ok, name} <- Map.fetch(user_data, :name),
           {:ok, email} <- Map.fetch(user_data, :email) do
        "User: #{name} <#{email}>"
      end

    assert_equal(Enlightenment.__(), result)

    # with advantages:
    # - Linear happy path logic
    # - Automatic error propagation
    # - Early return on first failure
    # - Clean variable scoping
    # - Composable error handling
    #
    # Without with (nested case):
    # case Map.fetch(user_data, :name) do
    #   {:ok, name} ->
    #     case Map.fetch(user_data, :email) do
    #       {:ok, email} -> "User: #{name} <#{email}>"
    #       error -> error
    #     end
    #   error -> error
    # end
    #
    # Common with patterns:
    # - API call chains
    # - Validation sequences
    # - File operations
    # - Database transactions
    # - Multi-step data transformations
  end

  def test_09_with_statement_failure do
    # CONCEPT: Explicit Error Handling with 'else'
    #
    # with can handle non-matching values explicitly using an else clause.
    # This gives you control over error handling and lets you transform
    # failure values into appropriate responses.

    # Missing email
    user_data = %{name: "Bob"}

    result =
      with {:ok, name} <- Map.fetch(user_data, :name),
           {:ok, email} <- Map.fetch(user_data, :email) do
        "User: #{name} <#{email}>"
      else
        :error -> "Missing data"
        _ -> "Unknown error"
      end

    assert_equal(Enlightenment.__(), result)

    # with error handling patterns:
    #
    # Simple error transformation:
    # with {:ok, result} <- api_call() do
    #   process(result)
    # else
    #   {:error, reason} -> {:error, "API failed: #{reason}"}
    # end
    #
    # Multiple error types:
    # with {:ok, user} <- fetch_user(id),
    #      {:ok, perms} <- check_permissions(user),
    #      {:ok, data} <- load_data(user) do
    #   present_data(data)
    # else
    #   {:error, :not_found} -> {:error, "User not found"}
    #   {:error, :forbidden} -> {:error, "Access denied"}
    #   {:error, reason} -> {:error, "Unexpected error: #{reason}"}
    # end
    #
    # Without else clause:
    # If no else clause, with returns the non-matching value directly
    # This is often what you want for error propagation
  end

  def test_10_for_comprehension_basic do
    # CONCEPT: Functional Data Transformation
    #
    # for comprehensions provide a clean, functional way to transform data.
    # They're similar to list comprehensions in Python or map operations
    # in functional languages, emphasizing transformation over mutation.

    numbers = [1, 2, 3, 4, 5]

    # Basic comprehension
    doubled = for n <- numbers, do: n * 2
    assert_equal(Enlightenment.__(), doubled)

    # for comprehension characteristics:
    # - Pure functional transformation
    # - No mutation of original data
    # - Returns new collection
    # - Lazy evaluation possible with Stream
    # - Multiple generators supported
    # - Filtering with guard conditions
    #
    # Comparison with imperative approach:
    #
    # Imperative (many languages):
    # result = []
    # for (let i = 0; i < numbers.length; i++) {
    #   result.push(numbers[i] * 2)
    # }
    #
    # Functional (Elixir):
    # doubled = for n <- numbers, do: n * 2
    #
    # The functional approach eliminates:
    # - Mutable variables
    # - Index management
    # - Manual iteration logic
    # - Potential off-by-one errors
  end

  def test_11_for_comprehension_with_filter do
    # CONCEPT: Filtering with Guard Conditions
    #
    # for comprehensions can include filter conditions that act as guards,
    # only including elements that match the condition. This combines
    # filtering and transformation in a single, readable expression.

    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    # Filter even numbers and square them
    even_squares = for n <- numbers, rem(n, 2) == 0, do: n * n
    assert_equal(Enlightenment.__(), even_squares)

    # Filter patterns:
    #
    # Multiple conditions:
    # for x <- list, x > 0, x < 100, rem(x, 3) == 0, do: x
    #
    # Type filtering:
    # for item <- mixed_list, is_integer(item), do: item * 2
    #
    # Pattern matching filters:
    # for {:ok, value} <- results, do: value  # Only successful results
    #
    # Complex conditions:
    # for user <- users, user.active?, not is_nil(user.email), do: user.email
    #
    # This replaces chains of Enum operations:
    # numbers |> Enum.filter(&rem(&1, 2) == 0) |> Enum.map(&(&1 * &1))
    # # vs
    # for n <- numbers, rem(n, 2) == 0, do: n * n
  end

  def test_12_for_comprehension_multiple_generators do
    # CONCEPT: Cartesian Product with Multiple Generators
    #
    # Multiple generators in for comprehensions create cartesian products,
    # combining every element from the first generator with every element
    # from subsequent generators. This is powerful for combinatorial problems.

    # Multiple generators create a cartesian product
    colors = [:red, :blue]
    sizes = [:small, :large]

    combinations = for color <- colors, size <- sizes, do: {color, size}
    assert_equal(Enlightenment.__(), combinations)

    # Multiple generator patterns:
    #
    # Coordinate generation:
    # for x <- 1..3, y <- 1..3, do: {x, y}
    # # [{1,1}, {1,2}, {1,3}, {2,1}, {2,2}, {2,3}, {3,1}, {3,2}, {3,3}]
    #
    # Configuration combinations:
    # for env <- [:dev, :prod], db <- [:mysql, :postgres], do: {env, db}
    #
    # Nested data processing:
    # for department <- company.departments,
    #     employee <- department.employees,
    #     employee.active? do
    #   {department.name, employee.name}
    # end
    #
    # With filters across generators:
    # for x <- 1..10, y <- 1..10, x + y == 10, do: {x, y}
    # # All pairs that sum to 10
  end

  def test_13_for_comprehension_into_map do
    # CONCEPT: Collecting Results into Different Structures
    #
    # The 'into' option allows you to collect comprehension results into
    # different data structures like maps, sets, or custom collectables.
    # This provides flexibility in the output format.

    list = [a: 1, b: 2, c: 3]

    # Transform into a different map
    doubled_map = for {key, value} <- list, into: %{}, do: {key, value * 2}
    assert_equal(Enlightenment.__(), doubled_map)

    # into options:
    #
    # Default (list):
    # for x <- data, do: transform(x)
    #
    # Into map:
    # for {k, v} <- data, into: %{}, do: {k, transform(v)}
    #
    # Into existing map:
    # for item <- new_items, into: existing_map, do: {item.id, item}
    #
    # Into binary:
    # for char <- 'hello', into: "", do: <<char + 1>>  # "ifmmp"
    #
    # Into MapSet:
    # for x <- list, into: MapSet.new(), do: x
    #
    # Custom collectables:
    # for item <- items, into: %MyStruct{}, do: transform(item)
    #
    # This is more efficient than:
    # data |> for(...) |> Enum.into(%{})
    # Because it builds the target structure directly
  end

  def test_14_try_rescue do
    # CONCEPT: Exception Handling
    #
    # try/rescue handles exceptions in Elixir. However, exceptions should be
    # rare - Elixir prefers explicit error handling with tagged tuples.
    # Use try/rescue for truly exceptional situations, not control flow.

    # Handle exceptions with try/rescue
    result1 =
      try do
        10 / 2
      rescue
        ArithmeticError -> "Math error"
      end

    result2 =
      try do
        10 / 0
      rescue
        ArithmeticError -> "Math error"
      end

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    # Exception handling philosophy:
    #
    # Elixir prefers:
    # {:ok, result} | {:error, reason}  # Explicit success/failure
    #
    # Over:
    # try/catch/rescue everywhere
    #
    # Use exceptions for:
    # - Truly exceptional situations
    # - Library boundaries
    # - Configuration errors
    # - System-level failures
    #
    # Use tagged tuples for:
    # - Expected failure modes
    # - Business logic errors
    # - User input validation
    # - API responses
    #
    # Exception types:
    # - RuntimeError: Generic runtime errors
    # - ArgumentError: Invalid function arguments
    # - ArithmeticError: Math operation failures
    # - KeyError: Missing key access
    # - FunctionClauseError: No matching function clause
  end

  def test_15_try_catch do
    # CONCEPT: Handling Throws vs Exceptions
    #
    # catch handles values thrown with throw/1, which is different from
    # exceptions raised with raise/1. Throws are for control flow,
    # while exceptions indicate errors. Both are rare in idiomatic Elixir.

    # Handle throws with try/catch
    result =
      try do
        throw(:ball)
      catch
        :ball -> "Caught the ball"
        value -> "Caught #{value}"
      end

    assert_equal(Enlightenment.__(), result)

    # throw/catch vs raise/rescue:
    #
    # throw/catch:
    # - Used for non-local returns
    # - Control flow mechanism
    # - Expected behavior
    # - Often used in deeply nested iterations
    #
    # raise/rescue:
    # - Used for error conditions
    # - Exceptional situations
    # - Program state problems
    # - Should be rare in good Elixir code
    #
    # Example throw usage (rare):
    # try do
    #   Enum.each(large_list, fn item ->
    #     if special_condition?(item), do: throw({:found, item})
    #   end)
    #   {:not_found}
    # catch
    #   {:found, item} -> {:found, item}
    # end
    #
    # Better Elixir approach:
    # Enum.find(large_list, &special_condition?/1)
  end

  def test_16_try_after do
    # CONCEPT: Guaranteed Cleanup with After
    #
    # The after clause always executes, regardless of whether the try block
    # succeeds, raises an exception, or catches a throw. This is essential
    # for resource cleanup like closing files, connections, or releasing locks.

    # after block always executes (like finally)
    {result, side_effect} =
      try do
        Agent.start_link(fn -> [] end)
        {"success", "cleanup executed"}
      after
        # This always runs
        :cleanup_code
      end

    # :ok from Agent.start_link
    assert_equal(Enlightenment.__(), elem(result, 0))

    # after clause guarantees:
    # - Always executes
    # - Executes even if exception occurs
    # - Executes even if throw occurs
    # - Good for resource cleanup
    # - Return value is ignored
    #
    # Resource management patterns:
    #
    # File handling:
    # try do
    #   file = File.open!(path)
    #   process_file(file)
    # after
    #   File.close(file)
    # end
    #
    # Database connections:
    # try do
    #   conn = get_connection()
    #   run_queries(conn)
    # after
    #   release_connection(conn)
    # end
    #
    # Better pattern - use with_* functions:
    # File.open(path, fn file -> process_file(file) end)
    # # File is automatically closed
    #
    # Or use GenServer/GenStateMachine for stateful resources
  end
end
