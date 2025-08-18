defmodule AboutMaps do
  @moduledoc """
  Maps are key-value data structures.
  They are the "go to" key-value data structure in Elixir.

  ## Understanding Maps in Elixir

  Maps are Elixir's primary key-value data structure, designed to replace
  HashDict and provide efficient, immutable key-value storage. They're the
  Swiss Army knife of Elixir data structures, suitable for everything from
  simple configuration to complex nested data.

  ## Key Characteristics

  - **Efficient**: O(log n) access, update, and insertion for large maps
  - **Immutable**: Operations return new maps, original unchanged
  - **Flexible keys**: Any type can be a key (atoms, strings, numbers, etc.)
  - **Pattern matchable**: Extract values with powerful pattern matching
  - **Enumerable**: Works with all Enum functions
  - **Ordered**: Small maps (≤32 keys) preserve insertion order

  ## Performance Characteristics

  - **Small maps (≤32 keys)**: Array-based, very fast access
  - **Large maps (>32 keys)**: Hash Array Mapped Trie (HAMT), O(log n)
  - **Memory efficient**: Structural sharing between versions
  - **Update patterns**: Prefer Map.put/3 over deep merging for performance

  ## When to Use Maps

  **Perfect for:**
  - Configuration data
  - JSON-like structures
  - Records with named fields
  - Caches and lookup tables
  - Nested data structures
  - API responses and data transfer

  **Consider alternatives for:**
  - Simple key-value pairs → Keyword lists
  - Fixed structure → Structs
  - Sequential data → Lists
  - Large datasets → ETS tables

  ## Map Patterns in Elixir

  Maps are ubiquitous in Elixir applications:
  - **Phoenix params**: `%{"name" => "John", "age" => "25"}`
  - **Config**: `%{database_url: "...", port: 4000}`
  - **JSON APIs**: Perfect match for JSON objects
  - **State management**: GenServer state, ETS records
  - **Data transformation**: Pipeline-friendly operations
  """

  import Enlightenment

  def test_01_creating_maps do
    # CONCEPT: Map Creation and Basic Operations
    #
    # Maps are created with %{} syntax. Empty maps are common starting points
    # for building up data structures or as default values in functions.
    # map_size/1 provides O(1) size checking.

    empty_map = %{}
    assert_equal(Enlightenment.__(), map_size(empty_map))

    person = %{"name" => "Alice", "age" => 30}
    assert_equal(Enlightenment.__(), person)

    # Map creation patterns:
    # %{}                               # Empty map
    # %{key: value}                     # Atom keys (shorthand)
    # %{"key" => value}                 # String keys
    # %{key_var => value}               # Variable keys (must use =>)
    # Map.new()                         # Empty map (functional style)
    # Map.new(enumerable)               # From enumerable
    #
    # Empty maps are useful as:
    # - Default function parameters: def process(data, opts \\ %{})
    # - Initial accumulators: Enum.reduce(list, %{}, accumulator_fn)
    # - Base for building complex structures
  end

  def test_02_map_with_atom_keys do
    # CONCEPT: Atom Keys and Syntax Sugar
    #
    # Atom keys are extremely common in Elixir applications because they
    # provide excellent performance and clean syntax. The key: value syntax
    # is syntactic sugar that only works with atom literals.

    # Maps with atom keys are very common
    config = %{host: "localhost", port: 4000, ssl: false}
    assert_equal(Enlightenment.__(), config)

    # Atom key advantages:
    # ✅ Fast comparison and hashing
    # ✅ Clean, readable syntax with key: value
    # ✅ Memory efficient (atoms are interned)
    # ✅ Perfect for internal application data
    #
    # When to use atom keys:
    # - Configuration data
    # - Internal data structures
    # - Function return values
    # - API response structure
    #
    # When to avoid:
    # - Dynamic/user-provided keys (memory risk)
    # - Large sets of keys from external sources
    # - Direct JSON compatibility requirements
  end

  def test_03_accessing_map_values do
    # CONCEPT: Multiple Access Patterns
    #
    # Maps provide several ways to access values, each with different
    # behavior for missing keys. Choose based on whether you want
    # nil, defaults, or errors for missing keys.

    person = %{name: "Bob", age: 25}

    # Use [] notation to access values
    assert_equal(Enlightenment.__(), person[:name])

    assert_equal(Enlightenment.__(), person[:age])

    # Non-existent key returns nil
    assert_equal(Enlightenment.__(), person[:height])

    # Access method comparison:
    # map[:key]                    # nil if missing
    # map.key                      # KeyError if missing (atoms only)
    # Map.get(map, :key)           # nil if missing
    # Map.get(map, :key, default)  # default if missing
    # Map.fetch(map, :key)         # {:ok, value} or :error
    # Map.fetch!(map, :key)        # value or KeyError
    #
    # Choose based on error handling needs:
    # - Use [] for optional values
    # - Use . notation when key must exist
    # - Use Map.get/3 for defaults
    # - Use Map.fetch/2 for explicit success/failure
  end

  def test_04_dot_notation_for_atom_keys do
    # CONCEPT: Compile-Time Key Validation
    #
    # Dot notation (map.key) provides compile-time guarantees that
    # the key exists and is an atom. This catches typos early and
    # makes code more reliable, but requires keys to exist.

    person = %{name: "Charlie", age: 35}

    # For atom keys, you can use dot notation
    assert_equal(Enlightenment.__(), person.name)

    assert_equal(Enlightenment.__(), person.age)

    # This only works for atom keys that exist at compile time

    # Dot notation characteristics:
    # ✅ Compile-time key validation
    # ✅ Clear intent: "this key must exist"
    # ✅ Catches typos early
    # ✅ Slightly better performance
    # ❌ Only works with atom keys
    # ❌ Keys must exist or KeyError is raised
    # ❌ Not suitable for dynamic keys
    #
    # Use dot notation when:
    # - Keys are known at compile time
    # - Missing key should be an error
    # - You want maximum safety and performance
  end

  def test_05_map_get_function do
    # CONCEPT: Safe Access with Defaults
    #
    # Map.get/2 and Map.get/3 provide explicit, safe access to map values.
    # They're more verbose than [] but make intentions clearer and support
    # default values, reducing the need for nil checking.

    person = %{name: "Diana", age: 28}

    # Map.get/2 is another way to access values
    assert_equal(Enlightenment.__(), Map.get(person, :name))

    # Map.get/3 allows you to provide a default value
    assert_equal(Enlightenment.__(), Map.get(person, :height, 0))

    # Map.get/3 advantages:
    # - Eliminates nil checking in many cases
    # - Makes default values explicit
    # - Works with any key type
    # - Functional programming friendly
    #
    # Common patterns:
    # Map.get(config, :timeout, 5000)        # Configuration with defaults
    # Map.get(params, "page", 1)              # Request parameters
    # Map.get(cache, cache_key, :miss)        # Cache lookups
  end

  def test_06_updating_maps do
    # CONCEPT: Immutable Updates
    #
    # All map modifications create new maps, leaving the original unchanged.
    # This immutability enables safe sharing between processes and prevents
    # accidental modifications, but requires understanding of functional patterns.

    person = %{name: "Eve", age: 32}

    # Use Map.put/3 to add or update a key
    updated = Map.put(person, :age, 33)
    assert_equal(Enlightenment.__(), updated[:age])

    # Original map unchanged
    assert_equal(Enlightenment.__(), person[:age])

    # Add a new key
    with_city = Map.put(person, :city, "New York")
    assert_equal(Enlightenment.__(), with_city[:city])

    # Update patterns and performance:
    # Map.put(map, key, value)          # O(log n) for large maps
    # Map.merge(map1, map2)             # Combines maps, right wins
    # Map.update(map, key, default, fn) # Update with function
    # Map.update!(map, key, fn)         # Update existing key
    #
    # Immutability benefits:
    # - Safe concurrent access
    # - Prevents accidental modifications
    # - Enables structural sharing (memory efficient)
    # - Supports undo/redo patterns
  end

  def test_07_update_syntax_for_existing_keys do
    # CONCEPT: Update Syntax for Safety
    #
    # The %{map | key: value} syntax provides compile-time safety by
    # only allowing updates to existing keys. This prevents typos and
    # makes code intentions clear: "modify existing data, don't add new fields."

    person = %{name: "Frank", age: 40}

    # Use the update syntax for existing keys (atom keys only)
    updated = %{person | age: 41}
    assert_equal(Enlightenment.__(), updated[:age])

    # This syntax requires the key to exist, or it will raise an error
    assert_raise KeyError, fn -> %{person | height: 180} end

    # Update syntax characteristics:
    # ✅ Compile-time key existence checking
    # ✅ Prevents accidental key addition
    # ✅ Clear intent: "update existing data"
    # ✅ Concise syntax
    # ❌ Only works with atom keys
    # ❌ Keys must already exist
    # ❌ Can't add new keys
    #
    # Use update syntax when:
    # - Modifying known, existing fields
    # - You want safety against typos
    # - Working with structured data (consider structs)
    #
    # Use Map.put/3 when:
    # - Adding new keys
    # - Working with dynamic keys
    # - Keys might not exist
  end

  def test_08_merge_maps do
    # CONCEPT: Combining Maps with Merge
    #
    # Map merging is essential for combining configuration, applying defaults,
    # and building complex data structures. Understanding conflict resolution
    # helps you control the outcome when keys overlap.

    person = %{name: "Grace", age: 29}
    details = %{city: "Boston", profession: "Engineer"}

    # Use Map.merge/2 to combine maps
    complete = Map.merge(person, details)
    assert_equal(Enlightenment.__(), complete[:name])

    assert_equal(Enlightenment.__(), complete[:city])

    # Later map wins on conflicts
    conflicting = %{age: 30, city: "Cambridge"}
    merged = Map.merge(person, conflicting)
    assert_equal(Enlightenment.__(), merged[:age])

    # Merge strategies and use cases:
    #
    # Basic merging:
    # Map.merge(defaults, user_config)    # Apply user preferences over defaults
    # Map.merge(base_data, api_response)  # Combine data sources
    #
    # Custom conflict resolution:
    # Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)  # Custom merger
    #
    # Common patterns:
    # - Configuration systems: defaults + environment + user
    # - Data aggregation: combining partial results
    # - API composition: merging responses from multiple services
    # - State updates: applying changes to existing state
  end

  def test_09_deleting_from_maps do
    # CONCEPT: Key Removal and Data Sanitization
    #
    # Map.delete/2 creates a new map without specified keys. This is
    # essential for data sanitization, removing temporary values,
    # and implementing access control.

    person = %{name: "Henry", age: 45, city: "Chicago"}

    # Use Map.delete/2 to remove keys
    without_city = Map.delete(person, :city)
    assert_equal(Enlightenment.__(), Map.has_key?(without_city, :city))

    assert_equal(Enlightenment.__(), without_city[:name])

    # Deletion patterns:
    # Map.delete(map, key)              # Remove single key
    # Map.drop(map, keys)               # Remove multiple keys
    # Map.take(map, keys)               # Keep only specified keys
    #
    # Common use cases:
    # - Remove sensitive data before logging
    # - Clean up temporary processing keys
    # - Implement field-level access control
    # - Sanitize data for external APIs
    # - Remove nil or empty values
    #
    # Performance note: O(log n) for each key in large maps
  end

  def test_10_map_keys_and_values do
    # CONCEPT: Extracting Map Structure
    #
    # Map.keys/1 and Map.values/1 extract the structure of a map,
    # useful for analysis, validation, and transformation. Note that
    # order is not guaranteed for these operations.

    grades = %{math: 85, english: 92, science: 88}

    # Get all keys
    keys = Map.keys(grades)
    assert_equal(Enlightenment.__(), Enum.sort(keys))

    # Get all values
    values = Map.values(grades)
    assert_equal(Enlightenment.__(), Enum.sort(values))

    # Structure extraction use cases:
    #
    # Validation:
    # required_keys = [:name, :email, :age]
    # Map.keys(user_data) |> Enum.all?(&(&1 in required_keys))
    #
    # Analysis:
    # Map.values(scores) |> Enum.sum() |> Kernel./(map_size(scores))  # Average
    #
    # Transformation:
    # Map.keys(config) |> Enum.map(&String.upcase(Atom.to_string(&1)))
    #
    # Security:
    # allowed_keys = [:public_name, :public_email]
    # Map.take(user_profile, allowed_keys)  # Only expose safe fields
  end

  def test_11_checking_map_membership do
    # CONCEPT: Key Existence Testing
    #
    # Map.has_key?/2 tests whether a key exists in a map without
    # retrieving the value. This is useful for validation, conditional
    # logic, and avoiding unnecessary computations.

    inventory = %{apples: 10, bananas: 5, oranges: 3}

    assert_equal(Enlightenment.__(), Map.has_key?(inventory, :apples))

    assert_equal(Enlightenment.__(), Map.has_key?(inventory, :grapes))

    # Key existence patterns:
    #
    # Validation:
    # if Map.has_key?(params, :required_field) do
    #   process(params)
    # else
    #   {:error, :missing_field}
    # end
    #
    # Conditional processing:
    # config = if Map.has_key?(env, :debug_mode), do: %{debug: true}, else: %{}
    #
    # Performance optimization:
    # # Avoid expensive computation if key missing
    # if Map.has_key?(cache, key) do
    #   Map.get(cache, key)
    # else
    #   expensive_computation() |> cache_result()
    # end
  end

  def test_12_map_pattern_matching do
    # CONCEPT: Destructuring Maps with Pattern Matching
    #
    # Pattern matching with maps is incredibly powerful, allowing you to
    # extract specific values while ensuring the map has the expected structure.
    # Only the keys you specify need to match - others are ignored.

    response = %{status: :ok, data: "Hello", code: 200}

    # Match specific keys
    %{status: status, data: data} = response
    assert_equal(Enlightenment.__(), status)

    assert_equal(Enlightenment.__(), data)

    # Match with literals
    %{status: :ok, code: code} = response
    assert_equal(Enlightenment.__(), code)

    # Pattern matching capabilities:
    #
    # Partial matching:
    # %{name: name} = person                    # Extract just name
    # %{status: :ok, data: data} = response     # Match status, extract data
    #
    # Function heads:
    # def handle_response(%{status: :ok, data: data}), do: {:success, data}
    # def handle_response(%{status: :error, reason: reason}), do: {:error, reason}
    #
    # Guards:
    # %{age: age} when age >= 18 = person      # Pattern + guard
    #
    # This makes error handling and data processing very clean and safe
  end

  def test_13_partial_map_pattern_matching do
    # CONCEPT: Selective Data Extraction
    #
    # Map pattern matching's killer feature is selective extraction - you
    # only match the keys you care about. This makes code more maintainable
    # and resilient to changes in data structure.

    user = %{id: 1, name: "Ian", email: "ian@example.com", active: true}

    # You don't need to match all keys
    %{name: username} = user
    assert_equal(Enlightenment.__(), username)

    # Match multiple keys
    %{id: user_id, active: is_active} = user
    assert_equal(Enlightenment.__(), user_id)

    assert_equal(Enlightenment.__(), is_active)

    # Selective matching advantages:
    #
    # Maintainability:
    # - Code only depends on fields it actually uses
    # - Adding new fields won't break existing pattern matches
    # - Clear documentation of what data is needed
    #
    # API evolution:
    # - Functions can handle both old and new versions of data
    # - Gradual migration of data structures
    # - Backwards compatibility built in
    #
    # Performance:
    # - Only extract what you need
    # - Avoid unnecessary variable bindings
    # - Clear optimization opportunities
  end

  def test_14_map_comprehension do
    # CONCEPT: Transforming Maps with Comprehensions
    #
    # Map comprehensions provide a clean, functional way to transform maps.
    # They work with any enumerable and can include filters, making them
    # perfect for data transformation pipelines.

    numbers = %{a: 1, b: 2, c: 3}

    # Double all values
    doubled = for {key, value} <- numbers, into: %{}, do: {key, value * 2}
    assert_equal(Enlightenment.__(), doubled)

    # Filter and transform
    evens = for {key, value} <- numbers, rem(value, 2) == 0, into: %{}, do: {key, value}
    assert_equal(Enlightenment.__(), evens)

    # Comprehension patterns:
    #
    # Basic transformation:
    # for {k, v} <- map, into: %{}, do: {k, transform(v)}
    #
    # Filtering:
    # for {k, v} <- map, condition(v), into: %{}, do: {k, v}
    #
    # Key transformation:
    # for {k, v} <- map, into: %{}, do: {String.upcase(k), v}
    #
    # Complex transformations:
    # for {k, %{score: score}} <- results, score > 80, into: %{} do
    #   {k, :passed}
    # end
    #
    # The into: %{} is crucial - without it, you get a list of tuples!
  end

  def test_15_nested_maps do
    # CONCEPT: Hierarchical Data with Nested Maps
    #
    # Nested maps are perfect for representing hierarchical data like JSON,
    # configuration, or complex application state. Elixir provides special
    # functions for safe navigation and updates in nested structures.

    data = %{
      user: %{
        name: "Julia",
        address: %{
          street: "123 Main St",
          city: "Portland"
        }
      }
    }

    # Access nested values
    assert_equal(Enlightenment.__(), data[:user][:name])

    assert_equal(Enlightenment.__(), data[:user][:address][:city])

    # Use get_in/2 for safe nested access
    assert_equal(Enlightenment.__(), get_in(data, [:user, :name]))

    # Returns nil if path doesn't exist
    assert_equal(Enlightenment.__(), get_in(data, [:user, :phone]))

    # Nested access patterns:
    #
    # Direct access (can crash):
    # data[:user][:address][:street]
    #
    # Safe access (returns nil):
    # get_in(data, [:user, :address, :street])
    #
    # With defaults:
    # get_in(data, [:user, :phone]) || "No phone"
    #
    # Dynamic paths:
    # path = [:user, :address, :city]
    # get_in(data, path)
    #
    # get_in/2 is essential for working with external data like JSON APIs
  end

  def test_16_updating_nested_maps do
    # CONCEPT: Deep Updates in Nested Structures
    #
    # Updating nested maps requires special functions since you need to
    # update intermediate maps while maintaining immutability throughout
    # the entire structure. The *_in functions handle this complexity.

    data = %{user: %{name: "Kevin", age: 30}}

    # Use put_in/3 to update nested values
    updated = put_in(data, [:user, :age], 31)
    assert_equal(Enlightenment.__(), updated[:user][:age])

    # Use update_in/3 to apply a function
    incremented = update_in(data, [:user, :age], &(&1 + 1))
    assert_equal(Enlightenment.__(), incremented[:user][:age])

    # Deep update functions:
    #
    # put_in/3: Set value at path
    # put_in(data, [:user, :email], "new@example.com")
    #
    # update_in/3: Transform value at path
    # update_in(data, [:user, :age], &(&1 + 1))
    #
    # get_and_update_in/3: Get old value and set new
    # get_and_update_in(data, [:user, :login_count], &{&1, &1 + 1})
    #
    # These functions:
    # - Handle intermediate map creation/updating
    # - Maintain immutability throughout
    # - Work with dynamic paths
    # - Are essential for nested state management
  end
end
