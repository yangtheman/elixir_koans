defmodule AboutEnumeration do
  @moduledoc """
  The Enum module provides functions for working with collections.
  It's one of the most important modules in Elixir.

  ## Understanding Enumeration in Elixir

  The Enum module is the Swiss Army knife of Elixir programming, providing
  a comprehensive suite of functions for working with any enumerable data
  structure. It embodies functional programming principles and makes data
  transformation elegant, readable, and efficient.

  ## Core Philosophy

  **Functional transformation over mutation:**
  - Original data is never modified
  - Operations return new data structures
  - Composable and predictable behavior
  - Side-effect free (except for side-effect functions like each)

  **Lazy evaluation ready:**
  - Works seamlessly with Stream for lazy processing
  - Memory efficient for large datasets
  - Infinite sequences possible with Stream

  **Protocol-based design:**
  - Works with any data structure implementing Enumerable
  - Lists, maps, ranges, streams, custom types
  - Consistent API across different collections

  ## Performance Considerations

  **Eager evaluation:**
  - Each Enum operation processes the entire collection
  - Creates intermediate collections in pipelines
  - Excellent for small to medium datasets

  **When to consider Stream:**
  - Large datasets (>10k elements)
  - Multiple transformation steps
  - Infinite or very large ranges
  - Memory constraints

  **Common performance patterns:**
  - Use Enum.reduce/3 for single-pass aggregations
  - Combine filter + map operations when possible
  - Consider specialized functions (sum, count, etc.)
  - Profile before optimizing

  ## Enumerable Data Structures

  - **Lists**: [1, 2, 3] - Most common, linked list
  - **Maps**: %{a: 1, b: 2} - Key-value pairs as tuples
  - **Ranges**: 1..10 - Efficient sequence representation
  - **MapSets**: MapSet.new([1, 2]) - Unique elements
  - **Streams**: Stream.cycle([1, 2]) - Lazy sequences
  - **Keyword lists**: [a: 1, b: 2] - Ordered key-value
  - **Tuples**: Via Tuple.to_list/1 conversion

  ## Functional Programming Patterns

  **Transform (map)**: Change each element
  **Filter (filter)**: Select subset based on criteria
  **Reduce (reduce)**: Aggregate to single value
  **Find (find/find_value)**: Locate specific elements
  **Test (all?/any?)**: Boolean queries on collections
  **Combine (zip/concat)**: Merge multiple collections
  **Group (group_by/chunk)**: Organize data by criteria
  **Sort (sort/sort_by)**: Order elements
  **Unique (uniq/uniq_by)**: Remove duplicates
  """

  import Enlightenment

  def test_01_enum_map do
    # CONCEPT: Transformation with Map
    #
    # Enum.map/2 is the fundamental transformation function in functional
    # programming. It applies a function to every element in a collection,
    # returning a new collection with the transformed elements.

    numbers = [1, 2, 3, 4, 5]

    # Transform each element
    doubled = Enum.map(numbers, fn x -> x * 2 end)
    assert_equal(Enlightenment.__(), doubled)

    # Using shorthand syntax
    tripled = Enum.map(numbers, &(&1 * 3))
    assert_equal(Enlightenment.__(), tripled)

    # Map characteristics:
    # - One-to-one transformation (same number of elements)
    # - Pure function (no side effects in mapper)
    # - Lazy evaluation available with Stream.map/2
    # - Works with any enumerable collection
    #
    # Common mapping patterns:
    #
    # Data extraction:
    # users |> Enum.map(& &1.name)
    #
    # Type conversion:
    # strings |> Enum.map(&String.to_integer/1)
    #
    # Structure transformation:
    # data |> Enum.map(fn item -> %{id: item.id, name: item.name} end)
    #
    # Mathematical operations:
    # coordinates |> Enum.map(fn {x, y} -> {x * 2, y * 2} end)
    #
    # The anonymous function syntax &(&1 * 3) is equivalent to fn x -> x * 3 end
    # &1 refers to the first argument of the anonymous function
  end

  def test_02_enum_filter do
    # CONCEPT: Selection with Filter
    #
    # Enum.filter/2 selects elements that satisfy a given condition,
    # creating a new collection containing only the matching elements.
    # This is the functional equivalent of SQL WHERE clauses.

    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    # Keep only elements that match the condition
    evens = Enum.filter(numbers, fn x -> rem(x, 2) == 0 end)
    assert_equal(Enlightenment.__(), evens)

    # Using shorthand
    odds = Enum.filter(numbers, &(rem(&1, 2) == 1))
    assert_equal(Enlightenment.__(), odds)

    # Filter characteristics:
    # - Predicate function returns true/false
    # - Result may be smaller than input
    # - Maintains order of original collection
    # - No elements modified, only selection
    #
    # Common filtering patterns:
    #
    # Condition-based selection:
    # users |> Enum.filter(& &1.active?)
    # orders |> Enum.filter(fn order -> order.total > 100 end)
    #
    # Type-based filtering:
    # mixed_list |> Enum.filter(&is_integer/1)
    #
    # Null/nil filtering:
    # values |> Enum.filter(& !is_nil(&1))
    #
    # Pattern matching in filter:
    # results |> Enum.filter(fn {:ok, _} -> true; _ -> false end)
    # # Better: results |> Enum.filter(&match?({:ok, _}, &1))
    #
    # Performance tip: filter before map when both are needed
    # data |> Enum.filter(condition) |> Enum.map(transformer)
  end

  def test_03_enum_reduce do
    # CONCEPT: Aggregation with Reduce
    #
    # Enum.reduce/3 is the most powerful enumeration function, capable of
    # implementing almost any other enumeration operation. It processes each
    # element to build up a single accumulated result.

    numbers = [1, 2, 3, 4, 5]

    # Sum all numbers
    sum = Enum.reduce(numbers, 0, fn x, acc -> x + acc end)
    assert_equal(Enlightenment.__(), sum)

    # Product of all numbers
    product = Enum.reduce(numbers, 1, &(&1 * &2))
    assert_equal(Enlightenment.__(), product)

    # Reduce anatomy: Enum.reduce(enumerable, initial_accumulator, reducer_fn)
    # - enumerable: the collection to process
    # - initial_accumulator: starting value for accumulation
    # - reducer_fn: (element, accumulator) -> new_accumulator
    #
    # Advanced reduce patterns:
    #
    # Building collections:
    # squares = Enum.reduce(1..5, [], fn x, acc -> [x * x | acc] end)
    # # Result: [25, 16, 9, 4, 1] (reversed due to prepending)
    #
    # Building maps:
    # word_counts = Enum.reduce(words, %{}, fn word, acc ->
    #   Map.update(acc, word, 1, &(&1 + 1))
    # end)
    #
    # Finding maximum with custom logic:
    # max_user = Enum.reduce(users, fn user, max ->
    #   if user.score > max.score, do: user, else: max
    # end)
    #
    # Complex state accumulation:
    # stats = Enum.reduce(numbers, %{sum: 0, count: 0}, fn x, acc ->
    #   %{sum: acc.sum + x, count: acc.count + 1}
    # end)
    #
    # Reduce is the building block for many specialized functions:
    # - Enum.sum/1, Enum.count/1, Enum.max/1, etc.
  end

  def test_04_enum_find do
    # CONCEPT: Element Discovery with Find
    #
    # Enum.find/2,3 searches for the first element matching a condition.
    # It's more efficient than filter when you only need the first match,
    # as it stops processing once a match is found.

    numbers = [1, 3, 5, 8, 9, 12]

    # Find first element matching condition
    first_even = Enum.find(numbers, fn x -> rem(x, 2) == 0 end)
    assert_equal(Enlightenment.__(), first_even)

    # Find with default value
    first_negative = Enum.find(numbers, -1, fn x -> x < 0 end)
    assert_equal(Enlightenment.__(), first_negative)

    # Find family functions:
    #
    # Enum.find/2,3: Returns the element or nil/default
    # Enum.find_value/2,3: Returns transformation of found element
    # Enum.find_index/2: Returns index of found element
    #
    # Performance characteristics:
    # - Short-circuits on first match (O(n) worst case, O(1) best case)
    # - More efficient than filter + hd for single results
    # - Returns nil if no match (or default if provided)
    #
    # Common find patterns:
    #
    # User lookup:
    # user = Enum.find(users, fn u -> u.id == target_id end)
    #
    # Configuration search:
    # setting = Enum.find(configs, & &1.environment == :production)
    #
    # Error detection:
    # error = Enum.find(results, &match?({:error, _}, &1))
    #
    # find_value for transformation:
    # name = Enum.find_value(users, fn
    #   %{id: ^target_id, name: name} -> name
    #   _ -> nil
    # end)
    #
    # This is more efficient than: users |> Enum.filter(...) |> List.first()
  end

  def test_05_enum_all_and_any do
    # CONCEPT: Boolean Queries on Collections
    #
    # Enum.all?/2 and Enum.any?/2 test whether elements in a collection
    # satisfy conditions. They're essential for validation, precondition
    # checking, and boolean logic over collections.

    positive_numbers = [1, 2, 3, 4, 5]
    mixed_numbers = [-1, 2, -3, 4]

    # Check if all elements match condition
    all_positive = Enum.all?(positive_numbers, fn x -> x > 0 end)
    assert_equal(Enlightenment.__(), all_positive)

    mixed_all_positive = Enum.all?(mixed_numbers, &(&1 > 0))
    assert_equal(Enlightenment.__(), mixed_all_positive)

    # Check if any element matches condition
    any_negative = Enum.any?(mixed_numbers, &(&1 < 0))
    assert_equal(Enlightenment.__(), any_negative)

    # Boolean query characteristics:
    # - Short-circuit evaluation (stops on first decisive result)
    # - all?/1: true if predicate true for ALL elements
    # - any?/1: true if predicate true for ANY element
    # - empty collection: all? returns true, any? returns false
    #
    # Logical relationships:
    # - all?(collection, pred) == !any?(collection, not pred)
    # - any?(collection, pred) == !all?(collection, not pred)
    #
    # Common usage patterns:
    #
    # Validation:
    # valid = Enum.all?(user_inputs, &valid_input?/1)
    # if valid, do: process(), else: show_errors()
    #
    # Preconditions:
    # if Enum.all?(services, & &1.healthy?), do: start_deployment()
    #
    # Feature detection:
    # has_admin = Enum.any?(users, & &1.role == :admin)
    #
    # Error checking:
    # has_errors = Enum.any?(results, &match?({:error, _}, &1))
    #
    # Permission verification:
    # can_access = Enum.all?(required_perms, &user_has_permission?(user, &1))
    #
    # Performance: More efficient than length(Enum.filter(...)) > 0
  end

  def test_06_enum_take_and_drop do
    # CONCEPT: Sequence Slicing and Pagination
    #
    # take/2 and drop/2 provide efficient ways to extract portions of
    # sequences. They're essential for pagination, sampling, and working
    # with data windows without processing entire collections.

    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    # Take first n elements
    first_three = Enum.take(numbers, 3)
    assert_equal(Enlightenment.__(), first_three)

    # Drop first n elements
    without_first_three = Enum.drop(numbers, 3)
    assert_equal(Enlightenment.__(), without_first_three)

    # Take last n elements (negative count)
    last_two = Enum.take(numbers, -2)
    assert_equal(Enlightenment.__(), last_two)

    # Slicing patterns:
    #
    # Enum.take(enum, n): First n elements
    # Enum.take(enum, -n): Last n elements
    # Enum.drop(enum, n): All except first n
    # Enum.drop(enum, -n): All except last n
    #
    # Pagination implementation:
    # page_size = 10
    # page_number = 2
    # page_data = data |> Enum.drop((page_number - 1) * page_size)
    #                  |> Enum.take(page_size)
    #
    # Sampling:
    # sample = large_dataset |> Enum.shuffle() |> Enum.take(100)
    #
    # Window processing:
    # recent_events = events |> Enum.take(-50)  # Last 50 events
    #
    # take_while and drop_while for condition-based slicing:
    # positives = numbers |> Enum.take_while(&(&1 > 0))
    # after_zero = numbers |> Enum.drop_while(&(&1 != 0))
    #
    # Performance: take/drop are efficient, especially for lists
    # They don't require processing the entire collection
  end

  def test_07_enum_chunk do
    # CONCEPT: Grouping Elements into Batches
    #
    # Chunking functions split collections into smaller groups of elements.
    # This is essential for batch processing, pagination, data organization,
    # and working with data that needs to be processed in fixed-size groups.

    numbers = [1, 2, 3, 4, 5, 6, 7, 8]

    # Split into chunks of size n
    pairs = Enum.chunk_every(numbers, 2)
    assert_equal(Enlightenment.__(), pairs)

    # Chunk into groups of 3
    triples = Enum.chunk_every(numbers, 3)
    assert_equal(Enlightenment.__(), triples)

    # Chunking variations:
    #
    # chunk_every(enum, count): Fixed-size chunks
    # chunk_every(enum, count, step): Overlapping chunks
    # chunk_by(enum, fun): Group consecutive elements by function result
    # chunk_while(enum, acc, chunk_fun): Custom chunking logic
    #
    # Batch processing pattern:
    # large_list
    # |> Enum.chunk_every(100)
    # |> Enum.each(fn batch ->
    #   # Process 100 items at a time
    #   process_batch(batch)
    # end)
    #
    # Database insertion:
    # records
    # |> Enum.chunk_every(1000)
    # |> Enum.each(&Repo.insert_all(Schema, &1))
    #
    # Grouping by property:
    # words = ["apple", "apricot", "banana", "cherry", "cranberry"]
    # by_first_letter = Enum.chunk_by(words, &String.first/1)
    # # [["apple", "apricot"], ["banana"], ["cherry", "cranberry"]]
    #
    # Sliding windows:
    # moving_averages = numbers
    # |> Enum.chunk_every(3, 1, :discard)
    # |> Enum.map(&(Enum.sum(&1) / length(&1)))
  end

  def test_08_enum_zip do
    # CONCEPT: Parallel Iteration and Data Combination
    #
    # Enum.zip/2 combines elements from multiple collections pairwise,
    # creating tuples of corresponding elements. It's perfect for relating
    # data from different sources or parallel processing.

    names = ["Alice", "Bob", "Charlie"]
    ages = [25, 30, 35]

    # Combine two lists element by element
    combined = Enum.zip(names, ages)
    assert_equal(Enlightenment.__(), combined)

    # Zip characteristics:
    # - Stops at shortest collection length
    # - Creates tuples of corresponding elements
    # - Useful for parallel processing
    # - Can be unzipped with Enum.unzip/1
    #
    # Common zip patterns:
    #
    # Creating maps from separate key/value lists:
    # map = Enum.zip(keys, values) |> Enum.into(%{})
    #
    # Parallel processing:
    # Enum.zip(urls, timeouts)
    # |> Enum.map(fn {url, timeout} ->
    #   fetch_with_timeout(url, timeout)
    # end)
    #
    # Coordinate processing:
    # Enum.zip(x_coords, y_coords)
    # |> Enum.map(fn {x, y} -> calculate_distance({x, y}, origin) end)
    #
    # Multiple collection zip:
    # [list1, list2, list3] |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
    #
    # Unzipping:
    # {names, ages} = Enum.unzip(combined)
    #
    # zip_with for custom combination:
    # sums = Enum.zip_with(list1, list2, &(&1 + &2))
  end

  def test_09_enum_with_index do
    # CONCEPT: Adding Positional Information
    #
    # with_index/1,2 adds index information to elements, creating tuples
    # of {element, index}. This is essential when you need both the value
    # and its position for processing or display.

    fruits = ["apple", "banana", "cherry"]

    # Add index to each element
    indexed = Enum.with_index(fruits)
    assert_equal(Enlightenment.__(), indexed)

    # Start index from 1
    indexed_from_one = Enum.with_index(fruits, 1)
    assert_equal(Enlightenment.__(), indexed_from_one)

    # Index patterns:
    #
    # Position-dependent processing:
    # items |> Enum.with_index() |> Enum.map(fn {item, idx} ->
    #   if rem(idx, 2) == 0, do: transform_even(item), else: transform_odd(item)
    # end)
    #
    # Numbered lists for display:
    # tasks |> Enum.with_index(1) |> Enum.map(fn {task, num} ->
    #   "#{num}. #{task.title}"
    # end)
    #
    # Finding element positions:
    # positions = data |> Enum.with_index() |> Enum.filter(fn {elem, _} ->
    #   matches_criteria?(elem)
    # end) |> Enum.map(&elem(&1, 1))
    #
    # CSV-like processing with row numbers:
    # rows |> Enum.with_index(1) |> Enum.map(fn {row, row_num} ->
    #   process_row(row, row_num)
    # end)
    #
    # Alternative: Enum.map + Range
    # indexed_alt = Enum.zip(fruits, 0..(length(fruits)-1))
    #
    # For more complex indexing, consider Stream.with_index/2
    # which allows custom index functions
  end

  def test_10_enum_group_by do
    # CONCEPT: Data Classification and Organization
    #
    # group_by/2 organizes elements into groups based on a classifier function.
    # It returns a map where keys are the classification results and values
    # are lists of elements that produced those keys.

    words = ["hello", "world", "elixir", "is", "awesome", "and", "fun"]

    # Group by string length
    by_length = Enum.group_by(words, &String.length/1)
    assert_equal(Enlightenment.__(), Map.get(by_length, 5))

    assert_equal(Enlightenment.__(), Map.get(by_length, 2))

    # group_by characteristics:
    # - Classifier function determines grouping key
    # - Result is a map with keys as classification results
    # - Values are lists of elements that produced each key
    # - Order within groups is preserved from original collection
    #
    # Common grouping patterns:
    #
    # Categorization:
    # users_by_role = Enum.group_by(users, & &1.role)
    # %{admin: [...], user: [...], guest: [...]}
    #
    # Time-based grouping:
    # orders_by_month = Enum.group_by(orders, fn order ->
    #   Date.beginning_of_month(order.created_at)
    # end)
    #
    # Status grouping:
    # tasks_by_status = Enum.group_by(tasks, & &1.status)
    # %{pending: [...], completed: [...], failed: [...]}
    #
    # Multiple criteria grouping:
    # grouped = Enum.group_by(data, fn item ->
    #   {item.category, item.priority}
    # end)
    #
    # Post-processing groups:
    # summaries = by_length |> Enum.map(fn {length, words} ->
    #   {length, length(words), Enum.join(words, ", ")}
    # end)
    #
    # Performance: O(n) time complexity, very efficient for large datasets
  end

  def test_11_enum_sort do
    # CONCEPT: Ordering and Comparison
    #
    # Sorting functions arrange elements according to comparison rules.
    # Elixir's sort functions are stable and use efficient algorithms,
    # supporting both natural ordering and custom comparison functions.

    numbers = [3, 1, 4, 1, 5, 9, 2, 6]

    # Sort in ascending order
    sorted_asc = Enum.sort(numbers)
    assert_equal(Enlightenment.__(), sorted_asc)

    # Sort in descending order
    sorted_desc = Enum.sort(numbers, :desc)
    assert_equal(Enlightenment.__(), sorted_desc)

    # Sorting variations:
    #
    # Enum.sort/1: Natural ascending order
    # Enum.sort/2: Custom comparator or :desc
    # Enum.sort_by/2,3: Sort by derived key
    #
    # Custom comparison:
    # by_absolute = Enum.sort(numbers, fn a, b -> abs(a) <= abs(b) end)
    #
    # Sort by derived key:
    # users_by_age = Enum.sort_by(users, & &1.age)
    # words_by_length = Enum.sort_by(words, &String.length/1, :desc)
    #
    # Complex sorting:
    # # Sort by priority (high first), then by due date (early first)
    # sorted_tasks = Enum.sort_by(tasks, fn task ->
    #   {-task.priority, task.due_date}
    # end)
    #
    # String sorting considerations:
    # - Default sort is lexicographic (character codes)
    # - For locale-aware sorting, use specialized libraries
    # - Case sensitivity matters: "A" < "a" in default sort
    #
    # Performance:
    # - Stable sort algorithm (equal elements maintain relative order)
    # - O(n log n) time complexity
    # - sort_by/3 caches key computations (efficient for expensive key functions)
  end

  def test_12_enum_uniq do
    # CONCEPT: Duplicate Removal and Uniqueness
    #
    # uniq functions remove duplicate elements from collections, keeping
    # only the first occurrence of each unique element. They're essential
    # for data cleaning and ensuring set-like behavior.

    numbers = [1, 2, 2, 3, 3, 3, 4]

    # Remove duplicates
    unique = Enum.uniq(numbers)
    assert_equal(Enlightenment.__(), unique)

    # Uniqueness variations:
    #
    # Enum.uniq/1: Remove exact duplicates
    # Enum.uniq_by/2: Remove duplicates by key function
    #
    # Uniqueness by derived property:
    # unique_by_name = Enum.uniq_by(users, & &1.name)
    # unique_by_email = Enum.uniq_by(accounts, &String.downcase(&1.email))
    #
    # Case-insensitive uniqueness:
    # words = ["Apple", "banana", "APPLE", "Banana", "cherry"]
    # unique_words = Enum.uniq_by(words, &String.downcase/1)
    # # ["Apple", "banana", "cherry"]
    #
    # Complex uniqueness criteria:
    # unique_coords = Enum.uniq_by(points, fn {x, y} -> {round(x), round(y)} end)
    #
    # Performance characteristics:
    # - O(n) average case, O(n²) worst case
    # - Maintains order of first occurrences
    # - Memory usage: O(n) for tracking seen elements
    #
    # Alternative approaches:
    # # For better performance with large datasets:
    # MapSet.new(list) |> MapSet.to_list()  # But loses order
    #
    # # For frequency analysis:
    # frequencies = Enum.frequencies(list)  # %{elem => count}
    # unique_with_counts = Map.to_list(frequencies)
    #
    # Data cleaning patterns:
    # clean_data = raw_data
    # |> Enum.uniq_by(&normalize_key/1)
    # |> Enum.filter(&valid?/1)
  end

  def test_13_enum_join do
    # CONCEPT: String Aggregation and Formatting
    #
    # join functions convert collections of elements into strings,
    # concatenating them with optional separators. This is essential
    # for display formatting, CSV generation, and string construction.

    words = ["Elixir", "is", "awesome"]

    # Join with separator
    sentence = Enum.join(words, " ")
    assert_equal(Enlightenment.__(), sentence)

    # Join without separator
    concatenated = Enum.join(words)
    assert_equal(Enlightenment.__(), concatenated)

    # Join patterns and use cases:
    #
    # CSV generation:
    # csv_row = Enum.join(values, ",")
    #
    # Path construction:
    # path = Enum.join(path_segments, "/")
    #
    # SQL IN clause:
    # ids_str = ids |> Enum.map(&to_string/1) |> Enum.join(",")
    # query = "SELECT * FROM users WHERE id IN (#{ids_str})"
    #
    # HTML list generation:
    # html = items |> Enum.map(&"<li>#{&1}</li>") |> Enum.join("\n")
    #
    # Error message aggregation:
    # error_msg = errors |> Enum.map(& &1.message) |> Enum.join("; ")
    #
    # Type considerations:
    # - Elements are converted to strings via to_string/1
    # - Works with any elements that implement String.Chars protocol
    # - Numbers, atoms, strings automatically convert
    # - Complex data structures may need explicit conversion
    #
    # Performance:
    # - More efficient than repeated string concatenation
    # - Single-pass algorithm builds result string
    # - For very large joins, consider IO lists for better memory usage
    #
    # Alternative for complex formatting:
    # formatted = Enum.map_join(items, ", ", &format_item/1)
    # # Equivalent to: items |> Enum.map(&format_item/1) |> Enum.join(", ")
  end

  def test_14_enum_chaining do
    # CONCEPT: Functional Composition with Pipelines
    #
    # The pipe operator |> enables elegant chaining of Enum operations,
    # creating readable data transformation pipelines. This is the essence
    # of functional programming in Elixir - composing simple operations.

    # Chain multiple Enum operations together
    result =
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      # Keep evens
      |> Enum.filter(&(rem(&1, 2) == 0))
      # Square them
      |> Enum.map(&(&1 * &1))
      # Take first 3
      |> Enum.take(3)
      # Sum them up
      |> Enum.sum()

    assert_equal(Enlightenment.__(), result)

    # Pipeline benefits:
    # - Left-to-right reading (natural flow)
    # - No nested function calls
    # - Easy to modify steps
    # - Clear transformation sequence
    # - Testable individual steps
    #
    # Pipeline design principles:
    #
    # Data flow clarity:
    # users
    # |> Enum.filter(& &1.active)           # Select active users
    # |> Enum.map(&normalize_user/1)        # Normalize data
    # |> Enum.group_by(& &1.department)     # Group by department
    # |> Enum.map(fn {dept, users} ->       # Aggregate per department
    #   {dept, length(users)}
    # end)
    #
    # Error handling in pipelines:
    # data
    # |> Enum.map(&safe_transform/1)        # Returns {:ok, val} | {:error, reason}
    # |> Enum.filter(&match?({:ok, _}, &1)) # Keep only successes
    # |> Enum.map(&elem(&1, 1))             # Extract values
    #
    # Performance considerations:
    # - Each step processes entire intermediate collection
    # - Consider Stream for large data or many transformations
    # - Combine operations when possible (filter_map, etc.)
    #
    # Debugging pipelines:
    # # Add intermediate inspection
    # result = data
    # |> Enum.filter(condition)
    # |> IO.inspect(label: "after filter")  # Debug output
    # |> Enum.map(transformer)
    # |> IO.inspect(label: "after map")
  end

  def test_15_enum_works_with_different_collections do
    # CONCEPT: Protocol-Based Enumeration
    #
    # Enum functions work with any data structure that implements the
    # Enumerable protocol. This provides a uniform API across different
    # collection types, making code more generic and reusable.

    # Enum works with lists, maps, ranges, etc.

    # With ranges
    range_sum = Enum.sum(1..5)
    assert_equal(Enlightenment.__(), range_sum)

    # With maps (gets key-value tuples)
    map = %{a: 1, b: 2, c: 3}
    keys = Enum.map(map, fn {key, _value} -> key end)
    assert_equal(Enlightenment.__(), Enum.sort(keys))

    # Enumerable collections in Elixir:
    #
    # Lists: [1, 2, 3]
    # - Most common enumerable
    # - Linked list structure
    # - Efficient for sequential processing
    #
    # Maps: %{a: 1, b: 2}
    # - Enumerated as {key, value} tuples
    # - Order not guaranteed (except small maps)
    # - Useful for key-value transformations
    #
    # Ranges: 1..10
    # - Memory efficient for sequences
    # - Can be infinite (Stream-like)
    # - Perfect for numeric operations
    #
    # MapSets: MapSet.new([1, 2, 3])
    # - Unique elements only
    # - Unordered enumeration
    # - Set operations available
    #
    # Keyword lists: [a: 1, b: 2]
    # - Ordered key-value pairs
    # - Allows duplicate keys
    # - Common for options/configurations
    #
    # Streams: Stream.cycle([1, 2, 3])
    # - Lazy enumeration
    # - Composable transformations
    # - Infinite sequences possible
    #
    # Generic enumeration patterns:
    # def process_collection(enumerable) do
    #   enumerable
    #   |> Enum.filter(&valid?/1)
    #   |> Enum.map(&transform/1)
    #   |> Enum.reduce(initial_state(), &accumulate/2)
    # end
    #
    # This works with ANY enumerable collection!
    #
    # Protocol implementation for custom types:
    # defimpl Enumerable, for: MyCustomCollection do
    #   def reduce(collection, acc, fun), do: ...
    #   def member?(collection, element), do: ...
    #   def count(collection), do: ...
    #   def slice(collection), do: ...
    # end
  end
end
