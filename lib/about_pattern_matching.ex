defmodule AboutPatternMatching do
  @moduledoc """
  Pattern matching is at the heart of Elixir.
  The = operator is actually the match operator, not assignment.

  ## Understanding Pattern Matching

  Pattern matching is perhaps the most distinctive and powerful feature of Elixir.
  It allows you to:
  - Destructure data
  - Assert the shape of data
  - Extract values from complex structures
  - Control program flow based on data structure
  - Write more expressive and safe code

  ## The Match Operator (=)

  The = operator doesn't assign values - it matches patterns. When a variable
  appears on the left side for the first time, it gets bound to the value.
  When it appears again, it checks for equality.

  ## Key Concepts

  - Left side is the pattern, right side is the data
  - Variables bind on their first occurrence in a pattern
  - Underscore (_) ignores values you don't need
  - Pin operator (^) prevents rebinding and asserts equality
  - Patterns can be nested arbitrarily deep
  - Failed matches raise MatchError

  ## Common Patterns

  - Tuples: {status, result} = {:ok, "data"}
  - Lists: [head | tail] = [1, 2, 3]
  - Maps: %{key: value} = %{key: "data", other: "ignored"}
  - Strings: "prefix" <> rest = "prefix_and_more"
  - Function heads: def func({:ok, data}), do: data

  ## Benefits

  - Makes data transformation explicit
  - Eliminates many common bugs (wrong data shape)
  - Enables powerful functional programming patterns
  - Makes code more readable and declarative
  - Replaces many conditional checks
  """

  import Enlightenment

  def test_01_simple_assignment_is_actually_matching do
    # CONCEPT: The Match Operator Fundamentals
    #
    # What looks like assignment is actually pattern matching. When Elixir
    # sees `x = 1`, it tries to make the left side match the right side.
    # Since `x` is an unbound variable, it binds to 1 to make the match succeed.

    x = 1
    assert_equal(Enlightenment.__(), x)

    # Think of it as: "Make x match 1"
    # Since x is unbound, it gets bound to 1
    # This is different from imperative languages where = means "assign"
    #
    # The power comes when the left side has more structure:
    # {a, b} = {1, 2}  # Matches and binds a=1, b=2
    # [h | t] = [1, 2, 3]  # Matches and binds h=1, t=[2, 3]
  end

  def test_02_matching_literal_values do
    # CONCEPT: Pattern Matching Against Literal Values
    #
    # You can pattern match against literal values to assert that data has
    # a specific shape or value. This is like an assertion that's built
    # into the language - if the pattern doesn't match, you get an error.

    # This succeeds - literal 1 matches literal 1
    1 = 1

    # This would fail because 1 doesn't match 2
    assert_raise MatchError, fn -> 1 = 2 end

    # Real-world examples:
    # {:ok, result} = some_function()  # Assert success, extract result
    # %{status: 200} = response        # Assert HTTP 200 status
    # [first | _rest] = list           # Assert non-empty list, get first

    # This makes your code fail fast when data doesn't have expected shape
  end

  def test_03_variables_bind_on_first_match do
    # CONCEPT: Variable Binding vs Equality Checking
    #
    # Variables behave differently depending on whether they're already bound:
    # - First occurrence: binds to the value
    # - Later occurrences: checks for equality

    # x binds to 1
    x = 1
    assert_equal(Enlightenment.__(), x)

    # Now x is bound, so this checks equality (succeeds because x == 1)
    1 = x

    # This would fail because x is 1, not 2:
    # 2 = x  # MatchError!

    # This behavior prevents accidental rebinding and makes matches more predictable
    # If you want to rebind, you need to use a different variable name
  end

  def test_04_pin_operator_prevents_rebinding do
    # CONCEPT: The Pin Operator (^) for Explicit Equality Checking
    #
    # Sometimes you want to check equality against an already-bound variable
    # without risking rebinding. The pin operator (^) "pins" a variable to
    # its current value for pattern matching.

    x = 1

    # Pin operator prevents rebinding - checks that x equals 1
    # Succeeds because x is 1
    ^x = 1

    # This fails because x is pinned to 1, can't match 2
    assert_raise MatchError, fn ->
      ^x = 2
    end

    # The pin operator is essential when:
    # - Matching in case statements: case value do ^expected -> ...
    # - Function guards: def func(x) when x == ^constant
    # - Preventing accidental rebinding in complex patterns
    #
    # Without pin: x = 2 would rebind x to 2
    # With pin: ^x = 2 checks if x equals 2, fails if not
  end

  def test_05_tuple_pattern_matching do
    # CONCEPT: Destructuring Tuples - Tagged Data
    #
    # Tuples are perfect for pattern matching because they have a fixed
    # structure. This is especially powerful with "tagged tuples" where
    # the first element identifies the type of data.

    tuple = {:ok, "success", 42}

    # Match all elements and bind them to variables
    {:ok, message, code} = tuple
    assert_equal(Enlightenment.__(), message)

    assert_equal(Enlightenment.__(), code)

    # Match with literal values and variables mixed
    {:ok, msg, 42} = tuple
    assert_equal(Enlightenment.__(), msg)

    # This pattern is ubiquitous in Elixir:
    # {:ok, user} = get_user(id)           # Assert success, extract user
    # {:error, reason} = validate(data)    # Assert error, extract reason
    # {x, y, z} = get_coordinates()        # Destructure 3D point
  end

  def test_06_list_pattern_matching do
    # CONCEPT: List Destructuring with Head and Tail
    #
    # List pattern matching is one of the most powerful features in functional
    # programming. It allows you to process lists recursively by separating
    # the first element (head) from the rest (tail).

    list = [1, 2, 3, 4]

    # Match head and tail - the foundation of list processing
    [head | tail] = list
    assert_equal(Enlightenment.__(), head)

    assert_equal(Enlightenment.__(), tail)

    # Match multiple elements at the start
    [first, second | rest] = list
    assert_equal(Enlightenment.__(), first)

    assert_equal(Enlightenment.__(), second)

    assert_equal(Enlightenment.__(), rest)

    # This enables powerful recursive patterns:
    # def sum([]), do: 0
    # def sum([head | tail]), do: head + sum(tail)
  end

  def test_07_map_pattern_matching do
    # CONCEPT: Map Pattern Matching - Structural Flexibility
    #
    # Maps are perfect for representing structured data, and pattern matching
    # makes extracting values elegant. Unlike tuples, you only need to match
    # the keys you care about - extra keys are ignored.

    person = %{name: "Alice", age: 30, city: "New York"}

    # Match specific keys - extra keys are ignored
    %{name: name, age: age} = person
    assert_equal(Enlightenment.__(), name)

    assert_equal(Enlightenment.__(), age)

    # You don't need to match all keys
    %{name: person_name} = person
    assert_equal(Enlightenment.__(), person_name)

    # Real-world examples:
    # %{status: 200, body: data} = http_response
    # %{user: %{email: email}} = nested_data    # Nested matching
    # %{"id" => id} = json_data                 # String keys from JSON
  end

  def test_08_pattern_matching_in_function_heads do
    # CONCEPT: Function Dispatch Based on Data Shape
    #
    # One of Elixir's most elegant features is defining multiple function
    # clauses that pattern match on their arguments. This enables clean
    # control flow based on data structure rather than conditional logic.

    defmodule MathHelper do
      # Pattern match on specific values
      def factorial(0), do: 1

      # Pattern match with guards for more complex conditions
      def factorial(n) when n > 0, do: n * factorial(n - 1)

      # Could add: def factorial(n) when n < 0, do: {:error, "negative number"}
    end

    assert_equal(Enlightenment.__(), MathHelper.factorial(0))

    assert_equal(Enlightenment.__(), MathHelper.factorial(5))

    # This approach is more readable than:
    # def factorial(n) do
    #   if n == 0 do
    #     1
    #   else
    #     n * factorial(n - 1)
    #   end
    # end
  end

  def test_09_pattern_matching_with_strings do
    # CONCEPT: String Pattern Matching and Binary Patterns
    #
    # Strings can be pattern matched in several ways. The most common is
    # matching prefixes with the concatenation operator (<>). This is
    # particularly useful for parsing and protocol detection.

    # Match string prefixes
    "Hello " <> rest = "Hello World"
    assert_equal(Enlightenment.__(), rest)

    # Pattern matching fails if the prefix doesn't match
    assert_raise MatchError, fn ->
      "Goodbye " <> _rest = "Hello World"
    end

    # Real-world examples:
    # "HTTP/" <> version = request_line        # Parse HTTP version
    # "data:" <> content = data_url            # Parse data URLs
    # "Bearer " <> token = auth_header         # Extract auth tokens
    #
    # For more complex string parsing, you might use:
    # <<prefix::binary-size(5), rest::binary>> = "Hello World"
  end

  def test_10_ignoring_values_with_underscore do
    # CONCEPT: Ignoring Values You Don't Need
    #
    # Often you only care about some parts of a data structure. The underscore
    # (_) is a special variable that matches anything but doesn't bind a value.
    # This makes your intent clear and avoids unused variable warnings.

    tuple = {:ok, "data", 200, "extra"}

    # Use _ for values you don't need
    {:ok, data, _status, _extra} = tuple
    assert_equal(Enlightenment.__(), data)

    # Multiple underscores are allowed
    {:ok, _, status_code, _} = tuple
    assert_equal(Enlightenment.__(), status_code)

    # You can also use named underscores for documentation:
    # {:ok, data, _http_status, _metadata} = response
    #
    # Named underscores still don't bind values, but make code more readable
    # They also don't trigger "unused variable" warnings
  end

  def test_11_nested_pattern_matching do
    # CONCEPT: Deep Pattern Matching in Complex Data Structures
    #
    # Pattern matching can go arbitrarily deep into nested data structures.
    # This allows you to extract deeply nested values in a single operation,
    # making data transformation very concise and readable.

    data = {:user, %{name: "Bob", details: {:age, 25}}}

    # Match the entire nested structure in one operation
    {:user, %{name: name, details: {:age, age}}} = data
    assert_equal(Enlightenment.__(), name)

    assert_equal(Enlightenment.__(), age)

    # This is much cleaner than imperative extraction:
    # {:user, user_map} = data
    # name = user_map.name
    # {:age, age} = user_map.details
    #
    # Deep matching makes data transformation pipelines very clean
  end

  def test_12_pattern_matching_failure do
    # CONCEPT: When Pattern Matching Fails - MatchError
    #
    # Pattern matching can fail when the structure of data doesn't match
    # the expected pattern. This raises a MatchError, which helps catch
    # data structure bugs early in development.

    # List length mismatch
    assert_raise MatchError, fn ->
      # Can't match 2 elements to 3 elements
      [1, 2] = [1, 2, 3]
    end

    # Map key mismatch
    assert_raise MatchError, fn ->
      # Required key 'a' not found
      %{a: 1} = %{b: 2}
    end

    # These failures are features, not bugs! They help you:
    # - Catch data structure changes early
    # - Document expected data shapes
    # - Fail fast instead of propagating bad data
    #
    # Use try/catch or case statements when failure is expected
  end

  def test_13_case_statement_pattern_matching do
    # CONCEPT: Pattern Matching in Case Statements
    #
    # Case statements combine pattern matching with control flow. Each clause
    # tries to match the value, and the first successful match executes.
    # This is like switch statements but much more powerful.

    value = {:ok, 42}

    result =
      case value do
        {:ok, number} -> "Got number: #{number}"
        {:error, reason} -> "Error: #{reason}"
        _ -> "Unknown"
      end

    assert_equal(Enlightenment.__(), result)

    # Case statements are perfect for:
    # - Handling different return types (ok/error tuples)
    # - Processing different message types
    # - Parsing different data formats
    # - State machine implementations
    #
    # The _ pattern matches anything (like default in switch)
  end

  def test_14_pattern_matching_with_guards do
    # CONCEPT: Guards Add Conditions to Patterns
    #
    # Sometimes pattern structure isn't enough - you need additional conditions.
    # Guards let you add boolean conditions to patterns, making matching
    # even more precise and expressive.

    value = 15

    result =
      case value do
        x when x < 10 -> "small"
        # This matches because 15 < 20
        x when x < 20 -> "medium"
        x when x < 100 -> "large"
        _ -> "huge"
      end

    assert_equal(Enlightenment.__(), result)

    # Guards can use:
    # - Comparison operators: <, >, ==, ===, !=, !==
    # - Boolean operators: and, or, not
    # - Type checks: is_integer, is_list, is_map, etc.
    # - Math functions: rem, div, abs, etc.
    # - Some built-in functions: length, byte_size, etc.
    #
    # Guards cannot use custom functions or have side effects
  end

  def test_15_multiple_assignment_through_pattern_matching do
    # CONCEPT: Simultaneous Multi-Variable Assignment
    #
    # Pattern matching allows you to assign multiple variables simultaneously,
    # which is both convenient and makes the relationship between variables
    # explicit. This is common when functions return multiple related values.

    {x, y, z} = {1, 2, 3}

    assert_equal(Enlightenment.__(), x)

    assert_equal(Enlightenment.__(), y)

    assert_equal(Enlightenment.__(), z)

    # This pattern is common for:
    # {width, height} = get_dimensions()
    # {min, max} = Enum.min_max(list)
    # {status, headers, body} = http_request()
    #
    # It's more expressive than separate assignments and ensures
    # all related values come from the same source
  end

  def test_16_pattern_matching_with_cons_operator do
    # CONCEPT: The Cons Operator [H|T] for List Processing
    #
    # The cons operator [head | tail] is fundamental to functional programming
    # with lists. It separates a list into its first element and the rest,
    # enabling elegant recursive processing.

    list = [1, 2, 3, 4, 5]

    # Match first two elements, ignore the rest
    [a, b | _] = list
    assert_equal(Enlightenment.__(), a)

    assert_equal(Enlightenment.__(), b)

    # Match complete list structure
    [1, 2, 3, 4, 5] = list

    # Match first element and capture rest
    [1 | rest] = list
    assert_equal(Enlightenment.__(), rest)

    # The cons operator enables classic functional patterns:
    # def length([]), do: 0
    # def length([_head | tail]), do: 1 + length(tail)
    #
    # def reverse(list), do: reverse(list, [])
    # def reverse([], acc), do: acc
    # def reverse([head | tail], acc), do: reverse(tail, [head | acc])
  end

  def test_17_pattern_matching_function_return_values do
    # CONCEPT: Pattern Matching on Function Results
    #
    # Pattern matching function return values is a key pattern in Elixir.
    # It lets you handle different outcomes (success/error) and extract
    # values in one operation. This makes error handling explicit and safe.

    defmodule FileHelper do
      def read_file("good.txt"), do: {:ok, "file contents"}
      def read_file("bad.txt"), do: {:error, "file not found"}
      def read_file(_), do: {:error, "unknown file"}
    end

    # Match successful result and extract contents
    {:ok, contents} = FileHelper.read_file("good.txt")
    assert_equal(Enlightenment.__(), contents)

    # Match error result and extract reason
    {:error, reason} = FileHelper.read_file("bad.txt")
    assert_equal(Enlightenment.__(), reason)

    # This pattern enforces explicit error handling:
    # If you expect {:ok, data} but get {:error, reason}, you get MatchError
    # This prevents ignoring errors accidentally
    #
    # For handling both cases, use case statements:
    # case FileHelper.read_file(filename) do
    #   {:ok, contents} -> process(contents)
    #   {:error, reason} -> handle_error(reason)
    # end
  end

  def test_18_pattern_matching_in_with_statements do
    # CONCEPT: The 'with' Statement for Sequential Pattern Matching
    #
    # The 'with' statement allows you to chain multiple pattern matches,
    # creating a pipeline that stops on the first failure. This is perfect
    # for operations that can fail at multiple steps.

    defmodule UserService do
      def get_user(1), do: {:ok, %{id: 1, name: "Alice", email: "alice@example.com"}}
      def get_user(_), do: {:error, "user not found"}

      def validate_email("alice@example.com"), do: {:ok, "valid"}
      def validate_email(_), do: {:error, "invalid email"}
    end

    result =
      with {:ok, user} <- UserService.get_user(1),
           {:ok, _validation} <- UserService.validate_email(user.email) do
        "User #{user.name} is valid"
      else
        {:error, reason} -> "Failed: #{reason}"
      end

    assert_equal(Enlightenment.__(), result)

    # 'with' is perfect for:
    # - Chaining operations that can fail
    # - Avoiding nested case statements
    # - Early return on first failure
    # - Maintaining readable sequential logic
  end

  def test_19_pattern_matching_with_binary_strings do
    # CONCEPT: Binary Pattern Matching for Parsing
    #
    # For more complex string parsing, you can use binary pattern matching.
    # This gives you byte-level control and is very efficient for parsing
    # binary protocols or fixed-format data.

    data = "Hello, World!"

    # Extract first byte and rest
    <<first_byte, rest::binary>> = data
    assert_equal(Enlightenment.__(), first_byte)

    assert_equal(Enlightenment.__(), rest)

    # Extract first 5 bytes
    <<prefix::binary-size(5), remainder::binary>> = data
    assert_equal(Enlightenment.__(), prefix)

    assert_equal(Enlightenment.__(), remainder)

    # Binary patterns are powerful for:
    # - Network protocol parsing
    # - File format processing
    # - Cryptographic operations
    # - Any byte-level data manipulation
  end
end
