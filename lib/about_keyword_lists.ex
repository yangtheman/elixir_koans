defmodule AboutKeywordLists do
  @moduledoc """
  Keyword lists are lists of two-element tuples where the first element is an atom.
  They are often used for options and configuration.

  ## Understanding Keyword Lists

  Keyword lists occupy a unique niche in Elixir's data ecosystem. They bridge
  the gap between lists and maps, providing ordered key-value storage with
  specific characteristics that make them perfect for certain use cases.

  ## What Are Keyword Lists?

  A keyword list is simply a list of two-element tuples where:
  - The first element (key) must be an atom
  - The second element (value) can be any type
  - Multiple entries with the same key are allowed
  - Order is preserved (insertion order)

  **Syntax sugar:** `[key: value]` is equivalent to `[{:key, value}]`

  ## Key Characteristics

  **Ordered:** Unlike maps, keyword lists maintain insertion order
  **Duplicate keys allowed:** Same key can appear multiple times
  **Atom keys only:** Keys must be atoms (compile-time constants)
  **List-based:** Inherits all list properties and behaviors
  **Pattern matchable:** Can be destructured like any list

  ## When to Use Keyword Lists

  **Perfect for:**
  - Function options and configuration
  - Small datasets where order matters
  - APIs that need to accept duplicate keys
  - Protocol implementations
  - DSL construction

  **Avoid for:**
  - Large datasets (O(n) access time)
  - Frequent key lookups
  - Dynamic or string keys
  - Performance-critical code

  ## Keyword Lists vs Maps vs Structs

  **Keyword Lists:**
  - Ordered, allows duplicates
  - Atom keys only
  - O(n) access
  - List-based operations

  **Maps:**
  - Unordered (except small maps), unique keys
  - Any key type
  - O(log n) access
  - Optimized for key-value operations

  **Structs:**
  - Fixed keys at compile time
  - Type checking and defaults
  - Pattern matching benefits
  - Better for domain modeling

  ## Performance Considerations

  - **Access**: O(n) - must traverse list
  - **Update**: O(n) - creates new list
  - **Size**: O(1) - length stored
  - **Memory**: Efficient for small lists

  For > ~20 key-value pairs, consider maps instead.

  ## Common Patterns

  **Function options:**
  ```elixir
  def fetch(url, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 5000)
    headers = Keyword.get(opts, :headers, [])
    # ...
  end
  ```

  **Configuration:**
  ```elixir
  config = [
    database: [
      host: "localhost",
      port: 5432,
      timeout: 15_000
    ]
  ]
  ```

  **DSL building:**
  ```elixir
  query = from u in User,
    where: u.active == true,
    select: u.name
  ```
  """

  import Enlightenment

  def test_creating_keyword_lists do
    # CONCEPT: Keyword List Structure and Syntax
    #
    # Keyword lists are fundamentally lists of tuples with atom keys.
    # The [key: value] syntax is syntactic sugar that makes them more
    # readable and easier to work with, especially for configuration.

    # Keyword lists are just lists of {atom, value} tuples
    options = [name: "Alice", age: 30, active: true]

    assert_equal(Enlightenment.__(), options)

    # Understanding the structure:
    # [key: value] is equivalent to [{:key, value}]
    # Multiple key-value pairs create a list of tuples
    #
    # Internal representation:
    # [a: 1, b: 2] == [{:a, 1}, {:b, 2}]
    #
    # This dual nature (list + key-value) gives keyword lists their unique properties:
    # - List operations work: length, ++, --, Enum functions
    # - Key-value access patterns available
    # - Pattern matching as lists
    # - Ordered like lists, not like maps
    #
    # Common creation patterns:
    # config = [host: "localhost", port: 4000, ssl: true]
    # options = [timeout: 5000, retries: 3, async: false]
    # metadata = [created_at: DateTime.utc_now(), version: "1.0"]
  end

  def test_keyword_list_sugar_syntax do
    # CONCEPT: Syntactic Sugar and Equivalence
    #
    # The [key: value] syntax is pure syntactic sugar for [{:key, value}].
    # Understanding this equivalence helps you recognize keyword lists
    # in different contexts and use them with list operations.

    # The [key: value] syntax is sugar for [{:key, value}]
    sugar_syntax = [host: "localhost", port: 4000]
    tuple_syntax = [{:host, "localhost"}, {:port, 4000}]

    assert_equal(Enlightenment.__(), sugar_syntax == tuple_syntax)

    # Syntax equivalence demonstrations:
    #
    # These are identical:
    # [a: 1, b: 2]
    # [{:a, 1}, {:b, 2}]
    #
    # Mixed syntax (valid but not recommended):
    # [a: 1, {:b, 2}]  # Works but inconsistent
    #
    # When sugar syntax can't be used:
    # key_var = :dynamic_key
    # list = [{key_var, "value"}]  # Variable keys require tuple syntax
    #
    # Whitespace sensitivity:
    # [key :value]    # Syntax error
    # [key: value]    # Correct
    # [key : value]   # Correct but unusual
    #
    # The sugar syntax only works with atom literals, not variables:
    # key = :my_key
    # [key: "value"]           # key is literal atom :key
    # [{key, "value"}]         # key is the variable content
  end

  def test_accessing_keyword_list_values do
    # CONCEPT: Key-Value Access Patterns
    #
    # Keyword lists provide several ways to access values by key.
    # Understanding the differences helps you choose the right method
    # for your error handling and default value needs.

    config = [database: "myapp", username: "admin", timeout: 5000]

    # Use Keyword.get/2 to access values
    assert_equal(Enlightenment.__(), Keyword.get(config, :database))

    assert_equal(Enlightenment.__(), Keyword.get(config, :timeout))

    # Access method comparison:
    #
    # Keyword.get/2,3: Safe access, returns nil or default
    # config[:key]: Bracket syntax, returns nil if missing
    # Keyword.fetch/2: Returns {:ok, value} or :error
    # Keyword.fetch!/2: Returns value or raises KeyError
    #
    # Performance characteristics:
    # - All access methods are O(n) - must traverse the list
    # - Early keys are found faster than later keys
    # - For frequent access, consider converting to map
    #
    # Missing key behavior:
    # Keyword.get(config, :missing)     # nil
    # config[:missing]                  # nil
    # Keyword.fetch(config, :missing)   # :error
    # Keyword.fetch!(config, :missing)  # KeyError
    #
    # When to use each:
    # - get/2,3: Most common, good defaults
    # - []: Concise for optional values
    # - fetch/2: Explicit error handling
    # - fetch!/2: When key must exist
  end

  def test_keyword_get_with_default do
    # CONCEPT: Default Values and Configuration Patterns
    #
    # Keyword.get/3 with defaults is the cornerstone of Elixir's
    # configuration patterns. It allows functions to accept options
    # while providing sensible defaults for missing values.

    config = [host: "localhost"]

    # Provide default values for missing keys
    port = Keyword.get(config, :port, 80)
    assert_equal(Enlightenment.__(), port)

    # Default value patterns:
    #
    # Simple defaults:
    # timeout = Keyword.get(opts, :timeout, 5000)
    # retries = Keyword.get(opts, :retries, 3)
    #
    # Computed defaults:
    # log_level = Keyword.get(opts, :log_level, if(dev_env?, do: :debug, else: :info))
    #
    # Nil vs explicit defaults:
    # # These are different:
    # Keyword.get(opts, :key, nil)     # Always returns nil if missing
    # Keyword.get(opts, :key)          # Returns nil if missing, but clearer intent
    #
    # Configuration merging pattern:
    # def start_server(opts \\ []) do
    #   config = [
    #     host: Keyword.get(opts, :host, "localhost"),
    #     port: Keyword.get(opts, :port, 4000),
    #     ssl: Keyword.get(opts, :ssl, false)
    #   ]
    #   # Start server with merged config
    # end
    #
    # This pattern enables:
    # start_server()                          # All defaults
    # start_server(port: 8080)               # Override one value
    # start_server(host: "0.0.0.0", ssl: true) # Override multiple values
  end

  def test_accessing_with_square_brackets do
    # CONCEPT: Bracket Syntax and Access Protocol
    #
    # The [] syntax works with keyword lists through the Access protocol,
    # providing familiar map-like access patterns. This makes keyword
    # lists feel natural for developers coming from other languages.

    settings = [theme: "dark", language: "en"]

    # You can also use [] syntax like with maps
    assert_equal(Enlightenment.__(), settings[:theme])

    # Returns nil
    assert_equal(Enlightenment.__(), settings[:missing])

    # Access protocol implementation:
    # The Access protocol allows [] syntax for various data structures:
    # - Maps: %{key: value}[key]
    # - Keyword lists: [key: value][key]
    # - Lists: [1, 2, 3][0] (by index)
    #
    # Benefits of bracket syntax:
    # - Familiar to developers from other languages
    # - Consistent with map access patterns
    # - Works in pipelines: opts[:debug] |> process_debug()
    # - Shorter than Keyword.get for simple cases
    #
    # Limitations:
    # - No default value support (returns nil)
    # - Same O(n) performance as other access methods
    # - Less explicit than Keyword.get
    #
    # Comparison:
    # settings[:theme]                    # "dark" or nil
    # Keyword.get(settings, :theme)       # "dark" or nil
    # Keyword.get(settings, :theme, "light") # "dark" or "light"
    #
    # Use bracket syntax when:
    # - Simple access without defaults
    # - Consistency with map-like code
    # - Part of data transformation pipelines
  end

  def test_updating_keyword_lists do
    # CONCEPT: Immutable Updates and List Semantics
    #
    # Keyword list updates follow immutable patterns, creating new lists
    # rather than modifying existing ones. The update semantics follow
    # list behavior rather than map behavior.

    original = [a: 1, b: 2]

    # Use Keyword.put/3 to add or update
    updated = Keyword.put(original, :c, 3)
    assert_equal(Enlightenment.__(), Keyword.get(updated, :c))

    # Update existing key
    modified = Keyword.put(original, :a, 10)
    assert_equal(Enlightenment.__(), Keyword.get(modified, :a))

    # Update operations and their semantics:
    #
    # Keyword.put/3: Add new or update first occurrence
    # Keyword.put_new/3: Add only if key doesn't exist
    # Keyword.delete/2: Remove all occurrences of key
    # Keyword.replace/3: Update existing key (error if missing)
    #
    # List-like behavior:
    # put/3 updates the FIRST occurrence of a key, not all occurrences
    # This differs from maps which have unique keys
    #
    # Performance implications:
    # - put/3: O(n) - may need to traverse entire list
    # - delete/2: O(n) - must check every element
    # - Updates create new lists (immutable)
    #
    # Functional update patterns:
    # config = original
    # |> Keyword.put(:timeout, 5000)
    # |> Keyword.put(:retries, 3)
    # |> Keyword.delete(:old_option)
    #
    # When many updates are needed, consider:
    # 1. Converting to map, updating, converting back
    # 2. Building new keyword list from scratch
    # 3. Using Keyword.merge/2 for bulk updates
  end

  def test_duplicate_keys_allowed do
    # CONCEPT: Duplicate Keys and Multi-Value Scenarios
    #
    # Unlike maps, keyword lists allow duplicate keys. This enables
    # use cases where multiple values for the same key make sense,
    # such as HTTP headers, command-line arguments, or configuration layers.

    # Unlike maps, keyword lists can have duplicate keys
    duplicates = [a: 1, b: 2, a: 3]

    # First occurrence is returned
    assert_equal(Enlightenment.__(), Keyword.get(duplicates, :a))

    # Get all values for a key
    all_a_values = Keyword.get_values(duplicates, :a)
    assert_equal(Enlightenment.__(), all_a_values)

    # Duplicate key semantics:
    #
    # Access behavior:
    # - get/2,3: Returns first occurrence
    # - []: Returns first occurrence
    # - get_values/2: Returns all occurrences as list
    #
    # Update behavior:
    # - put/3: Updates first occurrence
    # - delete/2: Removes ALL occurrences
    # - put_new/3: Only adds if key doesn't exist
    #
    # Real-world duplicate key scenarios:
    #
    # HTTP headers:
    # headers = [
    #   {"accept", "text/html"},
    #   {"accept", "application/json"},  # Multiple accept headers
    #   {"cache-control", "no-cache"}
    # ]
    #
    # Command-line arguments:
    # args = [file: "a.txt", file: "b.txt", verbose: true]
    # files = Keyword.get_values(args, :file)  # ["a.txt", "b.txt"]
    #
    # Configuration layers:
    # config = [
    #   env: :dev,      # Base environment
    #   env: :test,     # Override for testing
    #   debug: true
    # ]
    # current_env = Keyword.get(config, :env)  # :dev (first)
    #
    # This flexibility makes keyword lists perfect for scenarios where
    # order matters and multiple values for the same key are meaningful.
  end

  def test_13_keyword_lists_vs_maps do
    # CONCEPT: Choosing Between Data Structures
    #
    # Understanding when to use keyword lists vs maps is crucial for
    # writing idiomatic Elixir. Each has distinct advantages and
    # use cases that make them better suited for different scenarios.

    kw_list = [name: "Bob", age: 25]
    map = %{name: "Bob", age: 25}

    # They're not equal even with same data
    assert_equal(Enlightenment.__(), kw_list == map)

    # Convert between them
    kw_to_map = Enum.into(kw_list, %{})
    assert_equal(Enlightenment.__(), kw_to_map == map)

    # Structural differences:
    #
    # Keyword lists: [{:key, value}, ...]
    # Maps: %{key => value, ...}
    #
    # Decision matrix:
    #
    # Use Keyword Lists when:
    # ✅ Function options/configuration
    # ✅ Small datasets (< 20 items)
    # ✅ Order matters
    # ✅ Duplicate keys needed
    # ✅ Building DSLs
    # ✅ Protocol implementations
    #
    # Use Maps when:
    # ✅ Large datasets (performance)
    # ✅ Frequent key lookups
    # ✅ Complex nested structures
    # ✅ JSON-like data
    # ✅ Pattern matching on structure
    # ✅ Guaranteed unique keys
    #
    # Conversion patterns:
    #
    # Keyword list to map:
    # Enum.into(kw_list, %{})
    # Map.new(kw_list)
    #
    # Map to keyword list (loses duplicates):
    # Enum.to_list(map)
    #
    # Performance comparison:
    # Access: KW O(n) vs Map O(log n)
    # Update: KW O(n) vs Map O(log n)
    # Memory: KW better for small, Map better for large
    #
    # Hybrid approach for function options:
    # def process_data(data, opts \\ []) do
    #   # Convert to map for efficient internal processing
    #   config = Enum.into(opts, %{})
    #   timeout = Map.get(config, :timeout, 5000)
    #   # ...
    # end
  end

  def test_function_options_pattern do
    # CONCEPT: Function Options and API Design
    #
    # The function options pattern using keyword lists is fundamental
    # to Elixir API design. It provides flexibility without forcing
    # callers to specify every parameter, making APIs both powerful and easy to use.

    # Keyword lists are commonly used for function options
    defmodule FileHelper do
      def read_file(path, opts \\ []) do
        encoding = Keyword.get(opts, :encoding, "utf-8")
        mode = Keyword.get(opts, :mode, "read")

        "Reading #{path} with #{encoding} in #{mode} mode"
      end
    end

    result1 = FileHelper.read_file("test.txt")
    assert_equal(Enlightenment.__(), String.contains?(result1, "utf-8"))

    result2 = FileHelper.read_file("test.txt", encoding: "latin-1", mode: "binary")
    assert_equal(Enlightenment.__(), String.contains?(result2, "latin-1"))

    # Function options pattern advantages:
    #
    # 1. Backward compatibility: Adding new options doesn't break existing calls
    # 2. Selective overrides: Only specify what you want to change
    # 3. Self-documenting: Option names make intent clear
    # 4. Flexible ordering: Options can be in any order
    #
    # Best practices for function options:
    #
    # Use sensible defaults:
    # def connect(host, opts \\ []) do
    #   port = Keyword.get(opts, :port, 80)
    #   timeout = Keyword.get(opts, :timeout, 5000)
    #   ssl = Keyword.get(opts, :ssl, false)
    # end
    #
    # Document your options:
    # @doc """
    # Connects to a host.
    #
    # ## Options
    # - `:port` - Port number (default: 80)
    # - `:timeout` - Timeout in ms (default: 5000)
    # - `:ssl` - Enable SSL (default: false)
    # """
    #
    # Validate options when needed:
    # def process(data, opts \\ []) do
    #   valid_keys = [:timeout, :retries, :async]
    #   invalid = Keyword.keys(opts) -- valid_keys
    #   if invalid != [], do: raise ArgumentError, "Invalid options: #{inspect(invalid)}"
    # end
    #
    # Common option patterns:
    # - Boolean flags: async: true, debug: false
    # - Timeouts: timeout: 5000, retry_delay: 1000
    # - Callbacks: on_success: &handle_success/1
    # - Configuration: pool_size: 10, max_retries: 3
  end

  def test_05_keyword_list_ordering do
    # CONCEPT: Insertion Order Preservation
    #
    # Keyword lists maintain the order of insertion, which can be crucial
    # for scenarios where the sequence of key-value pairs matters, such as
    # command-line argument processing or configuration cascading.

    # Keyword lists maintain order (unlike maps in older Elixir)
    ordered = [third: 3, first: 1, second: 2]
    keys = Keyword.keys(ordered)

    assert_equal(Enlightenment.__(), keys)

    # Order preservation benefits:
    #
    # 1. Predictable iteration: Enum functions process in insertion order
    # 2. Configuration priority: First values can take precedence
    # 3. Display order: Maintain user-specified sequences
    # 4. Processing order: Execute operations in specified sequence
    #
    # Order-dependent use cases:
    #
    # Configuration cascading:
    # config = [
    #   log_level: :info,     # Base setting
    #   log_level: :debug,    # Development override
    #   log_level: :error     # Production override
    # ]
    # # First match wins with get/2
    #
    # Middleware pipeline:
    # middleware = [
    #   cors: CORSMiddleware,
    #   auth: AuthMiddleware,
    #   logging: LogMiddleware
    # ]
    # # Order matters for request processing
    #
    # Command-line argument processing:
    # args = [file: "a.txt", verbose: true, file: "b.txt"]
    # # Process files in order specified
    #
    # CSS-like cascading:
    # styles = [
    #   color: "red",
    #   font_size: "12px",
    #   color: "blue"        # Later values override earlier ones
    # ]
    #
    # Comparison with maps:
    # - Small maps (≤ 32 keys): Maintain insertion order (Elixir 1.2+)
    # - Large maps: No order guarantee
    # - Keyword lists: Always maintain order (they're lists!)
  end

  def test_merging_keyword_lists do
    # CONCEPT: Configuration Merging and Composition
    #
    # Keyword list merging is essential for composing configurations,
    # combining user options with defaults, and building flexible
    # configuration systems that support cascading and overrides.

    defaults = [timeout: 5000, retries: 3]
    user_opts = [timeout: 1000, debug: true]

    # Keyword.merge/2 combines them (latter wins on conflicts)
    merged = Keyword.merge(defaults, user_opts)

    assert_equal(Enlightenment.__(), Keyword.get(merged, :timeout))

    assert_equal(Enlightenment.__(), Keyword.get(merged, :retries))

    assert_equal(Enlightenment.__(), Keyword.get(merged, :debug))

    # Merging semantics and strategies:
    #
    # Keyword.merge/2:
    # - Right side wins for conflicts
    # - Maintains order from both lists
    # - Duplicate keys from right side override left side
    #
    # Configuration composition patterns:
    #
    # Layered configuration:
    # app_defaults = [host: "localhost", port: 4000]
    # env_config = [port: 8080, ssl: true]
    # user_config = [ssl: false, debug: true]
    #
    # final_config = app_defaults
    # |> Keyword.merge(env_config)
    # |> Keyword.merge(user_config)
    # # Result: [host: "localhost", port: 8080, ssl: false, debug: true]
    #
    # Function with defaults:
    # def start_server(user_opts \\ []) do
    #   defaults = [host: "0.0.0.0", port: 4000, workers: 10]
    #   config = Keyword.merge(defaults, user_opts)
    #   # Use merged config
    # end
    #
    # Conditional merging:
    # config = base_config
    # |> Keyword.merge(if dev_mode?, do: dev_config, else: [])
    # |> Keyword.merge(if debug?, do: debug_config, else: [])
    #
    # Deep merging for nested configs:
    # # For nested keyword lists, you might need custom logic
    # defp deep_merge(left, right) do
    #   Keyword.merge(left, right, fn _key, left_val, right_val ->
    #     if is_list(left_val) and is_list(right_val) do
    #       deep_merge(left_val, right_val)
    #     else
    #       right_val
    #     end
    #   end)
    # end
    #
    # Alternative merging with ++:
    # merged_with_concat = user_opts ++ defaults
    # # Note: This keeps ALL values, including duplicates
    # # First occurrence wins with get/2
  end
end
