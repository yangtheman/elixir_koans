defmodule AboutTuples do
  @moduledoc """
  Tuples are ordered collections of elements.
  They are stored contiguously in memory and are good for small, fixed-size collections.

  ## Understanding Tuples in Elixir

  Tuples are one of the fundamental data structures in Elixir, designed for storing
  small, fixed-size collections of related data. Unlike lists, tuples are stored
  contiguously in memory, making element access very efficient.

  ## Key Characteristics

  - **Fixed size**: Size is determined at creation time
  - **Ordered**: Elements maintain their position
  - **Heterogeneous**: Can contain different data types
  - **Immutable**: Cannot be modified in place
  - **Contiguous memory**: All elements stored together
  - **Zero-indexed**: First element is at index 0

  ## Performance Characteristics

  - Element access: O(1) - constant time by index
  - Size calculation: O(1) - size is stored with the tuple
  - Updates: O(n) - creates new tuple with copied elements
  - Memory efficient: No pointer overhead between elements

  ## Common Use Cases

  - **Return values**: {:ok, result} or {:error, reason}
  - **Coordinates**: {x, y} or {x, y, z}
  - **RGB colors**: {red, green, blue}
  - **Database records**: {id, name, email}
  - **Fixed configuration**: {host, port, protocol}

  ## When to Use Tuples vs Lists

  **Use Tuples for:**
  - Small, fixed-size collections (2-8 elements typically)
  - Known structure at compile time
  - Fast element access by index
  - Return values from functions
  - Representing records or structured data

  **Use Lists for:**
  - Variable-size collections
  - Sequential processing
  - Prepending elements frequently
  - Recursive algorithms
  - Unknown size at compile time

  ## Pattern Matching

  Tuples excel at pattern matching, making them perfect for:
  - Destructuring return values
  - Function dispatch based on tuple structure
  - Error handling with tagged tuples
  - Extracting specific values from structured data
  """

  import Enlightenment

  def test_01_creating_tuples do
    # CONCEPT: Tuple Creation and Basic Structure
    #
    # Tuples are created with curly braces {} and can contain any number of elements.
    # They're perfect for grouping related data that has a known, fixed structure.
    # Empty tuples are valid but rarely used in practice.

    empty_tuple = {}
    assert_equal(Enlightenment.__(), tuple_size(empty_tuple))

    coordinate = {3, 4}
    assert_equal(Enlightenment.__(), coordinate)

    # Common tuple patterns:
    # {x, y}                    # 2D coordinate
    # {:ok, result}             # Success result
    # {:error, reason}          # Error result
    # {red, green, blue}        # RGB color
    # {year, month, day}        # Date
    #
    # Tuples are immutable - once created, they cannot be changed
    # Any "update" operation creates a new tuple
  end

  def test_02_tuple_size do
    # CONCEPT: Tuple Size - Fixed and Efficient
    #
    # tuple_size/1 returns the number of elements in a tuple in constant time O(1).
    # The size is stored with the tuple, so this operation is very fast.
    # This is different from list length, which requires traversal.

    point_2d = {10, 20}
    point_3d = {10, 20, 30}

    assert_equal(Enlightenment.__(), tuple_size(point_2d))

    assert_equal(Enlightenment.__(), tuple_size(point_3d))

    # Tuple size is determined at creation and never changes:
    # tuple_size({1, 2, 3})        # 3
    # tuple_size({:ok, "data"})    # 2
    # tuple_size({})               # 0
    #
    # This makes tuples perfect for structured data where the
    # number of fields is known and fixed
  end

  def test_03_accessing_tuple_elements do
    # CONCEPT: Fast Element Access by Index
    #
    # elem/2 provides O(1) constant-time access to tuple elements by index.
    # This is one of the major advantages of tuples over lists, where
    # access by index requires O(n) traversal.

    colors = {:red, :green, :blue}

    # Access elements by zero-based index
    assert_equal(Enlightenment.__(), elem(colors, 0))

    assert_equal(Enlightenment.__(), elem(colors, 1))

    assert_equal(Enlightenment.__(), elem(colors, 2))

    # elem/2 will raise ArgumentError for invalid indices:
    # elem(colors, 3)  # ArgumentError: argument error
    # elem(colors, -1) # ArgumentError: argument error
    #
    # For safe access, you might wrap in try/rescue or use pattern matching
  end

  def test_04_updating_tuple_elements do
    # CONCEPT: Tuple Updates Create New Tuples
    #
    # Since tuples are immutable, "updating" an element creates a new tuple
    # with the changed element. put_elem/3 provides this functionality,
    # though it's O(n) since it must copy all elements.

    point = {1, 2, 3}

    # Create new tuple with element at index 1 changed to 99
    new_point = put_elem(point, 1, 99)
    assert_equal(Enlightenment.__(), new_point)

    # Original tuple is completely unchanged
    assert_equal(Enlightenment.__(), point)

    # Important considerations:
    # - put_elem/3 is relatively expensive for large tuples
    # - If you need frequent updates, consider using maps instead
    # - Immutability prevents accidental modifications
    # - Multiple processes can safely share the same tuple
  end

  def test_05_tuple_pattern_matching do
    # CONCEPT: Destructuring Tuples with Pattern Matching
    #
    # Pattern matching is where tuples really shine. You can destructure
    # a tuple into its component parts in a single operation, making
    # code more readable and eliminating the need for multiple elem/2 calls.

    person = {"Alice", 30, :engineer}

    # Destructure all elements into named variables
    {name, age, profession} = person
    assert_equal(Enlightenment.__(), name)

    assert_equal(Enlightenment.__(), age)

    assert_equal(Enlightenment.__(), profession)

    # Pattern matching advantages:
    # - Single operation extracts all values
    # - Clear, declarative code
    # - Compiler ensures tuple has expected structure
    # - Fails fast if structure doesn't match
    #
    # This is much cleaner than:
    # name = elem(person, 0)
    # age = elem(person, 1)
    # profession = elem(person, 2)
  end

  def test_06_partial_tuple_pattern_matching do
    # CONCEPT: Selective Pattern Matching with Wildcards
    #
    # You don't always need all elements from a tuple. Pattern matching
    # allows you to extract only the values you care about and ignore
    # the rest using underscore (_) wildcards.

    response = {:ok, "Success", 200}

    # Extract only the message, ignore the status code
    {:ok, message, _status_code} = response
    assert_equal(Enlightenment.__(), message)

    # Match just the first few elements (if tuple might be larger)
    {:ok, msg} = {:ok, "Hello"}
    assert_equal(Enlightenment.__(), msg)

    # Pattern matching strategies:
    # {:ok, data, _} = response              # Ignore last element
    # {status, _, _} = response              # Only care about first
    # {:error, reason} = error_response      # Extract error reason
    #
    # This selective extraction makes code more focused and readable
  end

  # Helper function for return value examples
  defp divide(a, b) do
    if b == 0 do
      {:error, "Division by zero"}
    else
      {:ok, a / b}
    end
  end

  def test_07_tuples_for_return_values do
    # CONCEPT: Tagged Tuples for Function Return Values
    #
    # Tagged tuples are a fundamental pattern in Elixir for function return values.
    # They make success/failure explicit and allow pattern matching on results.
    # This replaces exception-based error handling with explicit error values.

    result1 = divide(10, 2)
    result2 = divide(10, 0)

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    # Tagged tuple patterns:
    # {:ok, value}              # Success with result
    # {:error, reason}          # Error with explanation
    # {:ok, value, metadata}    # Success with extra info
    # {:noreply, state}         # GenServer continue processing
    #
    # Usage with pattern matching:
    # case divide(x, y) do
    #   {:ok, result} -> "Result: #{result}"
    #   {:error, reason} -> "Error: #{reason}"
    # end
  end

  def test_08_tuple_to_list_conversion do
    # CONCEPT: Converting Between Tuples and Lists
    #
    # Sometimes you need to convert between tuples and lists, typically
    # when interfacing with different APIs or when you need list-specific
    # operations like Enum functions.

    tuple = {:a, :b, :c}
    list = Tuple.to_list(tuple)
    assert_equal(Enlightenment.__(), list)

    # Convert back to tuple
    new_tuple = List.to_tuple(list)
    assert_equal(Enlightenment.__(), new_tuple)

    # When to convert:
    # Tuple -> List: When you need Enum operations, variable size
    # List -> Tuple: When you need fast access, fixed structure
    #
    # Common pattern:
    # coordinates = [{1, 2}, {3, 4}, {5, 6}]  # List of tuples
    # points = Enum.map(coordinates, &Tuple.to_list/1)  # Convert for processing
  end

  def test_09_appending_to_tuple do
    # CONCEPT: Adding Elements to Tuples
    #
    # Tuple.append/2 creates a new tuple with an additional element at the end.
    # This is O(n) operation since it must copy all existing elements.
    # Consider whether growing tuples is the right pattern for your use case.

    original = {:a, :b}
    new_tuple = Tuple.append(original, :c)

    assert_equal(Enlightenment.__(), new_tuple)

    # Original tuple is unchanged (immutability)
    assert_equal(Enlightenment.__(), original)

    # Performance consideration:
    # If you're frequently appending, consider:
    # 1. Starting with a larger tuple and using put_elem/3
    # 2. Using a list and converting to tuple when done
    # 3. Using a map if the structure is more dynamic
    #
    # Tuples work best when size is known and fixed
  end

  def test_10_deleting_from_tuple do
    # CONCEPT: Removing Elements from Tuples
    #
    # Tuple.delete_at/2 creates a new tuple with an element removed at
    # the specified index. Like all tuple modifications, this is O(n)
    # and creates a completely new tuple.

    original = {:a, :b, :c, :d}
    new_tuple = Tuple.delete_at(original, 1)

    assert_equal(Enlightenment.__(), new_tuple)

    # Use cases for deletion:
    # - Removing optional fields from structured data
    # - Cleaning up tuples before passing to other functions
    # - Error recovery by removing problematic elements
    #
    # Again, frequent deletion suggests a list or map might be better
  end

  def test_11_inserting_into_tuple do
    # CONCEPT: Inserting Elements into Tuples
    #
    # Tuple.insert_at/3 creates a new tuple with an element inserted at
    # a specific position. All elements at and after that position are
    # shifted right by one position.

    original = {:a, :c}
    new_tuple = Tuple.insert_at(original, 1, :b)

    assert_equal(Enlightenment.__(), new_tuple)

    # Insertion patterns:
    # Tuple.insert_at(tuple, 0, elem)           # Insert at beginning
    # Tuple.insert_at(tuple, tuple_size(tuple), elem)  # Insert at end (same as append)
    # Tuple.insert_at(tuple, 1, elem)          # Insert in middle
    #
    # Consider the performance implications of frequent insertions
  end

  def test_12_tuple_comparison do
    # CONCEPT: Tuple Comparison and Ordering
    #
    # Tuples are compared lexicographically - element by element from left to right.
    # The first differing element determines the result. This makes tuples
    # suitable for natural ordering of structured data.

    assert_equal(Enlightenment.__(), {1, 2} < {1, 3})

    assert_equal(Enlightenment.__(), {1, 2} < {2, 1})

    assert_equal(Enlightenment.__(), {1, 2, 3} < {1, 2, 4})

    # Comparison rules:
    # 1. Compare elements left to right
    # 2. First difference determines result
    # 3. Shorter tuple is less than longer if all compared elements equal
    # 4. Different types follow Elixir's term ordering
    #
    # This enables natural sorting: Enum.sort([{2, 1}, {1, 3}, {1, 2}])
  end

  def test_13_nested_tuples do
    # CONCEPT: Tuples Containing Other Tuples
    #
    # Tuples can contain other tuples, creating nested structures.
    # This is useful for representing hierarchical data like coordinates
    # in different dimensions, complex return values, or structured records.

    nested = {{1, 2}, {3, 4}}

    # Pattern match nested structure
    {{a, b}, {c, d}} = nested
    assert_equal(Enlightenment.__(), a)

    assert_equal(Enlightenment.__(), d)

    # Access using elem/2 twice
    first_pair = elem(nested, 0)
    first_element = elem(first_pair, 0)
    assert_equal(Enlightenment.__(), first_element)

    # Common nested tuple patterns:
    # {{x, y}, {width, height}}     # Rectangle
    # {:ok, {data, metadata}}       # Success with structured result
    # {:user, {name, {first, last}}} # Deeply nested user data
    #
    # Pattern matching makes nested access clean and safe
  end

  def test_14_tuples_vs_lists do
    # CONCEPT: Choosing Between Tuples and Lists
    #
    # Understanding when to use tuples vs lists is crucial for writing
    # efficient and idiomatic Elixir code. Each has different performance
    # characteristics and use cases.

    # Tuples: fixed-size, fast access, structured data
    tuple = {:ok, "result"}
    list = [:first, :second, :third]

    # Tuple access is O(1) - constant time
    assert_equal(Enlightenment.__(), elem(tuple, 1))

    # List head access is O(1), but accessing by index is O(n)
    assert_equal(Enlightenment.__(), hd(list))

    # Tuple updates create new tuple (O(n))
    new_tuple = put_elem(tuple, 1, "new result")
    assert_equal(Enlightenment.__(), new_tuple)

    # List prepending is very efficient O(1)
    new_list = [:zeroth | list]
    assert_equal(Enlightenment.__(), new_list)

    # Decision matrix:
    #
    # Tuples:
    # ✅ Small, fixed size (2-8 elements)
    # ✅ Fast element access by index
    # ✅ Pattern matching on structure
    # ✅ Return values, coordinates, records
    # ❌ Frequent updates
    # ❌ Variable size
    # ❌ Sequential processing
    #
    # Lists:
    # ✅ Variable size
    # ✅ Sequential processing
    # ✅ Functional operations (map, filter, reduce)
    # ✅ Prepending elements
    # ❌ Random access by index
    # ❌ Fixed structure validation
  end

  def test_15_tuple_destruction_and_construction_patterns do
    # CONCEPT: Advanced Tuple Patterns
    #
    # Tuples support various advanced patterns that make code more expressive
    # and help with common programming tasks like swapping values, extracting
    # data from complex structures, and handling multiple return values.

    # Swapping values using tuple pattern matching
    {a, b} = {10, 20}
    # Swap them
    {a, b} = {b, a}
    assert_equal(Enlightenment.__(), {a, b})

    # Multiple assignment pattern
    coordinates = {100, 200, 300}
    {x, y, z} = coordinates
    # Now we have three separate variables
    sum = x + y + z
    assert_equal(Enlightenment.__(), sum)

    # Function returning multiple values
    defmodule Calculator do
      def div_rem(a, b), do: {div(a, b), rem(a, b)}
    end

    {quotient, remainder} = Calculator.div_rem(17, 5)
    assert_equal(Enlightenment.__(), quotient)

    assert_equal(Enlightenment.__(), remainder)

    # These patterns make Elixir code more expressive and eliminate
    # the need for temporary variables or multiple function calls
  end
end
