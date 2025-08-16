defmodule AboutLists do
  @moduledoc """
  Lists are the most common data structure in Elixir.
  They are linked lists, not arrays.

  ## Understanding Lists in Elixir

  Lists are fundamental to functional programming and Elixir. Unlike arrays in
  imperative languages, Elixir lists are:
  - Linked lists (not contiguous memory)
  - Immutable (operations create new lists)
  - Optimized for prepending (adding to front)
  - Recursive in nature (head + tail structure)

  ## Performance Characteristics

  - Prepending: O(1) - very fast
  - Appending: O(n) - slower, avoid for large lists
  - Length: O(n) - must traverse entire list
  - Access by index: O(n) - no random access
  - Pattern matching: O(1) for head/tail

  ## When to Use Lists

  - Sequential data processing
  - Recursive algorithms
  - When you primarily add to the front
  - Functional programming patterns (map, reduce, filter)
  - Small to medium datasets where order matters

  ## When NOT to Use Lists

  - Random access by index is needed (use tuples or maps)
  - Frequent appending to end (consider list reversal patterns)
  - Very large datasets (consider streams or other structures)
  - When you need constant-time length calculation

  ## Common Patterns

  - Recursive processing: def process([]), do: ...; def process([h|t]), do: ...
  - Accumulator pattern: build result by prepending, then reverse
  - List comprehensions: for item <- list, condition, do: transform(item)
  - Pipeline processing with Enum module functions
  """

  import Enlightenment

  def test_01_creating_lists do
    # CONCEPT: List Literals and Basic Structure
    #
    # Lists in Elixir are created with square brackets. They can be empty
    # or contain any number of elements of any type. Each list is either
    # empty ([]) or has a head (first element) and tail (rest of the list).

    empty_list = []
    assert_equal(Enlightenment.__(), empty_list)

    list_of_numbers = [1, 2, 3, 4, 5]
    assert_equal(Enlightenment.__(), list_of_numbers)

    # Lists are heterogeneous - can contain different types
    mixed_list = [1, "hello", :atom, 3.14]
    # This is perfectly valid in Elixir!

    # Lists are immutable - operations create new lists
    # original_list = [1, 2, 3]
    # new_list = [0 | original_list]  # Creates [0, 1, 2, 3]
    # original_list is still [1, 2, 3]
  end

  def test_02_list_head_and_tail do
    # CONCEPT: Head/Tail Structure - The Foundation of List Processing
    #
    # Every non-empty list has a head (first element) and tail (rest).
    # This recursive structure is fundamental to functional programming
    # and enables elegant recursive algorithms.

    list = [1, 2, 3, 4, 5]

    # hd/1 gets the first element (head)
    assert_equal(Enlightenment.__(), hd(list))

    # tl/1 gets everything except the first element (tail)
    assert_equal(Enlightenment.__(), tl(list))

    # Head/tail structure enables recursive patterns:
    # def sum([]), do: 0                    # Base case: empty list
    # def sum([head | tail]), do: head + sum(tail)  # Recursive case
    #
    # This pattern is so common that most list processing follows it:
    # - Process the head element
    # - Recursively process the tail
    # - Combine results
  end

  def test_03_list_construction_with_cons_operator do
    # CONCEPT: The Cons Operator (|) - Building Lists Efficiently
    #
    # The | operator (cons) is used to construct lists by prepending elements.
    # This operation is O(1) constant time, making it very efficient for
    # building lists incrementally in functional style.

    # Prepend single element to existing list
    list = [1 | [2, 3, 4]]
    assert_equal(Enlightenment.__(), list)

    # You can cons multiple elements at once
    list2 = [1, 2 | [3, 4]]
    assert_equal(Enlightenment.__(), list2)

    # Building lists with cons is idiomatic:
    # def build_range(0), do: [0]
    # def build_range(n), do: [n | build_range(n-1)]
    #
    # This creates: build_range(3) -> [3, 2, 1, 0]
    #
    # Cons is much faster than appending:
    # [element | list]     # O(1) - fast
    # list ++ [element]    # O(n) - slow for large lists
  end

  def test_04_list_pattern_matching do
    # CONCEPT: List Deconstruction with Pattern Matching
    #
    # Pattern matching is the idiomatic way to work with lists in Elixir.
    # It allows you to destructure lists and extract elements in a single
    # operation, making code more readable and less error-prone.

    list = [1, 2, 3, 4]

    # Extract head and tail
    [head | tail] = list
    assert_equal(Enlightenment.__(), head)

    assert_equal(Enlightenment.__(), tail)

    # Extract multiple elements from the front
    [first, second | rest] = list
    assert_equal(Enlightenment.__(), first)

    assert_equal(Enlightenment.__(), second)

    assert_equal(Enlightenment.__(), rest)

    # Pattern matching enables elegant function definitions:
    # def process_list([]), do: :done
    # def process_list([single]), do: {:single, single}
    # def process_list([first, second | _rest]), do: {:pair, first, second}
  end

  def test_05_list_concatenation do
    # CONCEPT: List Concatenation with ++
    #
    # The ++ operator concatenates two lists by creating a new list.
    # Note: this is O(n) where n is the length of the left list.
    # For better performance, consider prepending and reversing.

    list1 = [1, 2, 3]
    list2 = [4, 5, 6]

    combined = list1 ++ list2
    assert_equal(Enlightenment.__(), combined)

    # Performance consideration:
    # [1, 2, 3] ++ [4, 5, 6]  # Must traverse first list completely
    #
    # More efficient pattern for building lists:
    # 1. Build in reverse with cons: [6, 5, 4, 3, 2, 1]
    # 2. Reverse at the end: Enum.reverse/1
    #
    # This is O(n) total instead of O(n²) for repeated concatenation
  end

  def test_06_list_subtraction do
    # CONCEPT: List Subtraction with --
    #
    # The -- operator removes elements from the first list that appear
    # in the second list. It only removes the first occurrence of each
    # element, making it useful for set-like operations.

    list1 = [1, 2, 3, 2, 1]
    list2 = [1, 2]

    result = list1 -- list2
    assert_equal(Enlightenment.__(), result)

    # List subtraction characteristics:
    # - Removes first occurrence only: [1,2,1,2] -- [1] -> [2,1,2]
    # - Order matters: [1,2,3] -- [2,1] -> [3]
    # - Non-existent elements ignored: [1,2,3] -- [4,5] -> [1,2,3]
    #
    # Useful for:
    # - Removing specific items from lists
    # - Set difference operations
    # - Filtering out unwanted elements
  end

  def test_07_list_membership do
    # CONCEPT: Testing List Membership with 'in'
    #
    # The 'in' operator tests whether an element exists in a list.
    # It returns true/false and is equivalent to Enum.member?/2.
    # This is O(n) operation - must potentially check every element.

    list = [1, 2, 3, 4, 5]

    assert_equal(Enlightenment.__(), 3 in list)

    assert_equal(Enlightenment.__(), 6 in list)

    # Alternative approaches:
    # Enum.member?(list, 3)        # Same as 'in' operator
    # Enum.any?(list, &(&1 == 3))  # More flexible with custom conditions
    #
    # For frequent membership tests, consider using MapSets:
    # set = MapSet.new([1, 2, 3, 4, 5])
    # MapSet.member?(set, 3)  # O(1) instead of O(n)
  end

  def test_08_list_length do
    # CONCEPT: List Length - An O(n) Operation
    #
    # Getting list length requires traversing the entire list, making it
    # O(n) operation. This is different from arrays where length is O(1).
    # Consider this cost when designing algorithms.

    list = [1, 2, 3, 4, 5]

    assert_equal(Enlightenment.__(), length(list))

    assert_equal(Enlightenment.__(), length([]))

    # Performance implications:
    # - Avoid length/1 in loop conditions if possible
    # - Consider tracking length separately if needed frequently
    # - Use pattern matching to detect empty lists: [] instead of length(list) == 0
    #
    # Better patterns:
    # # Instead of: if length(list) > 0, do: process(list)
    # case list do
    #   [] -> :empty
    #   [_|_] -> process(list)
    # end
  end

  def test_09_list_reversal do
    # CONCEPT: List Reversal - A Common Operation
    #
    # Reversing lists is common in functional programming, especially
    # when building lists with cons (which naturally builds in reverse).
    # Enum.reverse/1 is efficient and implemented in C.

    list = [1, 2, 3, 4, 5]

    assert_equal(Enlightenment.__(), Enum.reverse(list))

    # Common pattern - build reversed, then reverse:
    # def build_list(items, acc \\ []) do
    #   case items do
    #     [] -> Enum.reverse(acc)              # Reverse at the end
    #     [head | tail] -> build_list(tail, [process(head) | acc])
    #   end
    # end
    #
    # This is efficient because:
    # 1. Prepending (cons) is O(1)
    # 2. Single reverse at end is O(n)
    # 3. Total is O(n) instead of O(n²) from repeated appending
  end

  def test_10_list_sorting do
    # CONCEPT: List Sorting and Ordering
    #
    # Sorting is a fundamental operation. Elixir provides efficient
    # sorting via Enum.sort/1 and Enum.sort/2. The default uses
    # Erlang's merge sort algorithm.

    list = [3, 1, 4, 1, 5, 9, 2, 6]

    assert_equal(Enlightenment.__(), Enum.sort(list))

    assert_equal(Enlightenment.__(), Enum.sort(list, :desc))

    # Custom sorting with functions:
    # Enum.sort(words, &(String.length(&1) <= String.length(&2)))  # By length
    # Enum.sort(people, &(&1.age <= &2.age))                       # By age
    # Enum.sort_by(people, & &1.name)                              # Extract key first
    #
    # sort_by/2 is often more readable for complex sorting criteria
  end

  def test_11_accessing_list_elements do
    # CONCEPT: List Element Access - No Random Access
    #
    # Lists don't support efficient random access like arrays.
    # Enum.at/2 must traverse from the beginning, making it O(n).
    # Consider other data structures if you need frequent index access.

    list = [:a, :b, :c, :d, :e]

    # Access by index (0-based, O(n) operation)
    assert_equal(Enlightenment.__(), Enum.at(list, 0))

    assert_equal(Enlightenment.__(), Enum.at(list, 2))

    # Negative indices count from end
    assert_equal(Enlightenment.__(), Enum.at(list, -1))

    # More efficient alternatives:
    # - First element: hd(list) or pattern match [first | _]
    # - Last element: List.last(list) - still O(n) but clearer intent
    # - If you need frequent random access, consider tuples or maps
  end

  def test_12_list_comprehension do
    # CONCEPT: List Comprehensions - Elegant Data Transformation
    #
    # List comprehensions provide a concise, readable way to transform
    # and filter lists. They're syntactic sugar over Enum functions
    # but often more readable for simple transformations.

    numbers = [1, 2, 3, 4, 5]

    # Transform: square all numbers
    squares = for n <- numbers, do: n * n
    assert_equal(Enlightenment.__(), squares)

    # Filter and transform: square even numbers only
    even_squares = for n <- numbers, rem(n, 2) == 0, do: n * n
    assert_equal(Enlightenment.__(), even_squares)

    # List comprehensions can:
    # - Iterate over multiple collections: for x <- list1, y <- list2
    # - Have multiple filters: for x <- list, x > 0, rem(x, 2) == 0
    # - Generate into different collections: for x <- list, into: %{}
    #
    # Equivalent to: Enum.map(Enum.filter(numbers, &(rem(&1, 2) == 0)), &(&1 * &1))
  end

  def test_13_nested_lists do
    # CONCEPT: Lists of Lists - Representing 2D Data
    #
    # Lists can contain other lists, creating nested structures.
    # This is useful for representing matrices, trees, or hierarchical data.
    # Standard list functions work recursively with nested structures.

    matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    # Access first row
    first_row = hd(matrix)
    assert_equal(Enlightenment.__(), first_row)

    # Flatten nested lists into single list
    flat = List.flatten(matrix)
    assert_equal(Enlightenment.__(), flat)

    # Working with nested lists:
    # - Access element: matrix |> Enum.at(1) |> Enum.at(2)  # Row 1, Col 2
    # - Map over rows: Enum.map(matrix, &Enum.sum/1)        # Sum each row
    # - Transpose: List.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  def test_14_list_with_mixed_types do
    # CONCEPT: Heterogeneous Lists - Mixed Data Types
    #
    # Unlike statically typed languages, Elixir lists can contain
    # elements of different types. This flexibility is useful but
    # requires careful handling to avoid runtime errors.

    mixed = [1, "hello", :atom, [1, 2], %{key: "value"}]

    assert_equal(Enlightenment.__(), length(mixed))

    assert_equal(Enlightenment.__(), Enum.at(mixed, 1))

    # Working with mixed lists safely:
    # - Use pattern matching: case elem do; int when is_integer(int) -> ...
    # - Use type guards: Enum.filter(mixed, &is_integer/1)
    # - Use protocols: Enum.map(mixed, &String.Chars.to_string/1)
    #
    # Consider using structs or maps for more structured heterogeneous data
  end

  def test_15_improper_lists do
    # CONCEPT: Improper Lists - When Tail Isn't a List
    #
    # Normal lists end with an empty list []. Improper lists end with
    # a non-list value. They're rare in practice but important to understand
    # because they can cause unexpected errors.

    # Create improper list: tail is 3, not []
    improper = [1, 2 | 3]

    # Many list functions fail on improper lists
    assert_raise ArgumentError, fn -> length(improper) end

    # Proper list: [1, 2 | []] or just [1, 2]
    # Improper list: [1, 2 | 3]
    #
    # Improper lists can occur when:
    # - Manually constructing with cons operator
    # - Receiving data from Erlang code
    # - Parsing certain data formats
    #
    # Always ensure lists are proper when using standard list functions
    # Use is_list/1 to check: is_list([1, 2]) -> true, is_list([1|2]) -> false
  end

  def test_16_list_enumeration_patterns do
    # CONCEPT: Common List Processing Patterns
    #
    # Lists are commonly processed using the Enum module, which provides
    # functional programming patterns like map, filter, and reduce.
    # These patterns are fundamental to idiomatic Elixir code.

    numbers = [1, 2, 3, 4, 5]

    # Map: transform each element
    doubled = Enum.map(numbers, &(&1 * 2))
    assert_equal(Enlightenment.__(), doubled)

    # Filter: select elements matching condition
    evens = Enum.filter(numbers, &(rem(&1, 2) == 0))
    assert_equal(Enlightenment.__(), evens)

    # Reduce: combine elements into single value
    sum = Enum.reduce(numbers, 0, &(&1 + &2))
    assert_equal(Enlightenment.__(), sum)

    # Pipeline processing:
    # numbers
    # |> Enum.filter(&(rem(&1, 2) == 0))    # Keep evens
    # |> Enum.map(&(&1 * 2))                # Double them
    # |> Enum.sum()                         # Sum result
    #
    # This functional approach is more composable and testable than imperative loops
  end

  def test_17_list_performance_characteristics do
    # CONCEPT: Understanding List Performance
    #
    # Lists have specific performance characteristics that affect
    # algorithm choice. Understanding these helps write efficient code.

    # Demonstration list
    list = [1, 2, 3, 4, 5]

    # O(1) operations - very fast
    # Add to front
    prepended = [0 | list]
    assert_equal(Enlightenment.__(), prepended)

    # O(n) operations - slower for large lists
    # Add to end (slow!)
    appended = list ++ [6]
    assert_equal(Enlightenment.__(), appended)

    # Performance guidelines:
    # ✅ DO: Prepend with [item | list]
    # ✅ DO: Build reversed, then Enum.reverse/1 at end
    # ❌ AVOID: Repeated appending with ++
    # ❌ AVOID: Frequent length/1 calls
    # ❌ AVOID: Random access with Enum.at/2 in loops
    #
    # For frequent appending or random access, consider other data structures:
    # - :queue for efficient front/back operations
    # - Tuple for fixed-size random access
    # - Map for key-based access
  end
end
