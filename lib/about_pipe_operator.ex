defmodule AboutPipeOperator do
  @moduledoc """
  The pipe operator |> is one of Elixir's most beloved features.
  It allows you to chain function calls in a readable way.

  ## Understanding the Pipe Operator

  The pipe operator (|>) is syntactic sugar that transforms nested function
  calls into a readable, left-to-right data flow. It takes the result of
  the expression on its left and passes it as the first argument to the
  function on its right.

  ## The Philosophy of Pipes

  The pipe operator embodies functional programming's emphasis on data
  transformation pipelines. Instead of thinking about procedures that
  modify state, you think about data flowing through a series of
  transformations, each step producing a new value.

  ## Syntax and Semantics

  **Basic transformation:**
  ```
  data |> function(arg2, arg3)
  ```
  **Becomes:**
  ```
  function(data, arg2, arg3)
  ```

  **The key insight:** The pipe always passes the left side as the
  **first argument** to the function on the right side.

  ## Benefits of Pipe Operator

  **Readability:** Left-to-right data flow matches human reading patterns
  **Composition:** Easy to build complex transformations from simple parts
  **Debugging:** Can insert inspection at any step
  **Refactoring:** Easy to add, remove, or reorder transformations
  **Functional style:** Encourages immutable data transformations

  ## When to Use Pipes

  **Perfect for:**
  - Multi-step data transformations
  - Processing pipelines (2+ steps)
  - Functional programming patterns
  - Data cleaning and validation
  - API response processing

  **Avoid for:**
  - Single function calls (overkill)
  - Complex branching logic
  - When intermediate values need reuse
  - Performance-critical code (minimal overhead, but worth noting)

  ## Common Patterns and Idioms

  **Data validation pipeline:**
  ```elixir
  user_input
  |> String.trim()
  |> String.downcase()
  |> validate_email()
  |> normalize_format()
  ```

  **Collection processing:**
  ```elixir
  data
  |> Enum.map(&transform/1)
  |> Enum.filter(&valid?/1)
  |> Enum.reduce(&combine/2)
  ```

  **Error handling with case:**
  ```elixir
  result
  |> process_data()
  |> case do
    {:ok, value} -> handle_success(value)
    {:error, reason} -> handle_error(reason)
  end
  ```

  ## Design Philosophy

  The pipe operator encourages designing functions that:
  - Take the "main" data as the first argument
  - Return transformed data (immutable)
  - Have descriptive names that read like verbs
  - Are composable and focused on single responsibilities

  This leads to more maintainable, testable, and readable code that
  naturally follows functional programming principles.
  """

  import Enlightenment

  def test_01_basic_pipe_usage do
    # CONCEPT: Pipe Operator Fundamentals and Readability
    #
    # The pipe operator transforms nested function calls into readable
    # left-to-right data flow. This matches how humans naturally think
    # about step-by-step processes.

    # Without pipes
    result1 = String.upcase(String.trim("  hello world  "))

    # With pipes - much more readable!
    result2 =
      "  hello world  "
      |> String.trim()
      |> String.upcase()

    assert_equal(Enlightenment.__(), result1 == result2)

    assert_equal(Enlightenment.__(), result2)

    # Pipe operator mechanics:
    #
    # The transformation is purely syntactic:
    # data |> func() becomes func(data)
    # data |> func(arg) becomes func(data, arg)
    #
    # Reading pipes vs nested calls:
    #
    # Nested (inside-out, hard to follow):
    # upcase(trim(downcase(strip(input))))
    #
    # Piped (left-to-right, natural flow):
    # input
    # |> strip()
    # |> downcase()
    # |> trim()
    # |> upcase()
    #
    # Mental model benefits:
    # - Start with raw data
    # - Apply transformations step by step
    # - Each step produces new value
    # - Final result at the end
    #
    # This mirrors how we describe processes:
    # "Take the input, trim it, then uppercase it"
    # vs "Uppercase the result of trimming the input"
    #
    # Formatting conventions:
    # - Each pipe on its own line for multi-step operations
    # - Align pipes vertically
    # - Use descriptive function names that read like actions
    # - Consider the "story" your pipeline tells
    #
    # Performance note: Pipes have zero runtime overhead
    # They're purely compile-time syntax transformations
  end

  def test_02_pipe_with_multiple_arguments do
    # CONCEPT: Argument Position and Function Design
    #
    # The pipe operator always inserts the left side as the FIRST argument
    # of the function on the right. This influences how Elixir functions
    # are designed and why they follow specific parameter conventions.

    # The pipe puts the left side as the FIRST argument of the right side
    result =
      "hello"
      |> String.replace("l", "L")
      |> String.replace("o", "O")

    assert_equal(Enlightenment.__(), result)

    # Argument placement patterns:
    #
    # Elixir functions are designed with the "primary data" first:
    # String.replace(string, pattern, replacement)
    # Enum.map(enumerable, function)
    # Map.put(map, key, value)
    #
    # This enables natural piping:
    # "hello"
    # |> String.replace("l", "L")        # String.replace("hello", "l", "L")
    # |> String.replace("o", "O")        # String.replace("heLLo", "o", "O")
    #
    # Design principle: "Data-first" functions
    # The thing being transformed/processed comes first
    # Configuration/parameters come after
    #
    # Comparison with other languages:
    # JavaScript: string.replace(pattern, replacement)  # Method on object
    # Python: string.replace(old, new)                  # Method on object
    # Elixir: String.replace(string, pattern, replacement) # Data-first function
    #
    # Benefits for piping:
    # ✅ Natural data flow
    # ✅ Consistent parameter ordering
    # ✅ Composable transformations
    # ✅ Easy to reason about
    #
    # When designing your own functions:
    # # Good: Data first
    # def process_user(user, options), do: ...
    # user |> process_user(opts)
    #
    # # Less ideal: Data not first
    # def process_user(options, user), do: ...
    # # Harder to pipe naturally
  end

  def test_03_pipe_with_anonymous_functions do
    # CONCEPT: Anonymous Functions and Lambda Piping
    #
    # Pipes work with anonymous functions, but require explicit calling
    # syntax. This demonstrates the flexibility of the pipe operator
    # and how it works with different function types.

    # You can pipe into anonymous functions too
    add_exclamation = fn str -> str <> "!" end
    make_title_case = fn str -> String.capitalize(str) end

    result =
      "hello world"
      |> String.replace(" ", "_")
      |> make_title_case.()
      |> add_exclamation.()

    assert_equal(Enlightenment.__(), result)

    # Anonymous function piping syntax:
    #
    # For anonymous functions, you must use the .() calling syntax:
    # data |> anonymous_func.()           # Correct
    # data |> anonymous_func              # Won't work
    #
    # Different function types in pipes:
    #
    # Named functions:
    # data |> String.upcase()
    #
    # Anonymous functions:
    # upcase_fn = &String.upcase/1
    # data |> upcase_fn.()
    #
    # Function captures:
    # data |> (&String.upcase/1).()       # Explicit call
    # data |> (&String.upcase(&1))        # Won't work in pipe
    #
    # Inline lambdas:
    # data |> (fn x -> String.upcase(x) end).()
    #
    # When to use anonymous functions in pipes:
    #
    # ✅ Custom transformation logic
    # ✅ One-off processing steps
    # ✅ Conditional transformations
    # ✅ Wrapping existing functions
    #
    # Example patterns:
    #
    # Conditional processing:
    # result = data
    # |> (fn x -> if valid?(x), do: process(x), else: x end).()
    #
    # Wrapping for piping:
    # save_and_return = fn data ->
    #   save_to_db(data)
    #   data  # Return for continued piping
    # end
    #
    # Complex transformations:
    # complex_transform = fn %{name: name, age: age} ->
    #   %{display_name: String.upcase(name), decade: div(age, 10)}
    # end
    #
    # user |> complex_transform.() |> save_user()
  end

  def test_04_pipe_with_function_capture do
    # CONCEPT: Function Capture Syntax in Pipes
    #
    # Function capture syntax (&) creates anonymous functions efficiently
    # and integrates well with pipes, especially for collection processing
    # and functional programming patterns.

    # Using function capture with pipes
    numbers = [1, 2, 3, 4, 5]

    result =
      numbers
      # Square each number
      |> Enum.map(&(&1 * &1))
      # Keep only > 10
      |> Enum.filter(&(&1 > 10))
      # Sum them up
      |> Enum.sum()

    assert_equal(Enlightenment.__(), result)

    # Function capture patterns in pipes:
    #
    # Basic capture syntax:
    # &(&1 * 2)                    # fn x -> x * 2 end
    # &String.upcase/1             # fn x -> String.upcase(x) end
    # &MyModule.process(&1, opts)  # fn x -> MyModule.process(x, opts) end
    #
    # Common collection processing patterns:
    #
    # Map transformations:
    # numbers |> Enum.map(&(&1 * 2))           # Double each
    # strings |> Enum.map(&String.upcase/1)    # Uppercase each
    # users |> Enum.map(&(&1.name))            # Extract property
    #
    # Filter operations:
    # numbers |> Enum.filter(&(&1 > 10))       # Greater than 10
    # users |> Enum.filter(&(&1.active))       # Active users
    # items |> Enum.filter(&valid?/1)          # Valid items
    #
    # Find operations:
    # users |> Enum.find(&(&1.id == target_id))
    #
    # Reduce patterns:
    # numbers |> Enum.reduce(0, &(&1 + &2))    # Sum
    # strings |> Enum.reduce("", &(&2 <> &1))  # Concatenate
    #
    # Nested function captures:
    # data
    # |> Enum.map(&(&1.items))                 # Extract items
    # |> Enum.concat()                         # Flatten
    # |> Enum.filter(&(&1.status == :active))  # Filter
    #
    # When function capture shines:
    # - Simple, one-line transformations
    # - Collection processing
    # - Property extraction
    # - Simple predicates
    #
    # When to use regular functions instead:
    # - Complex logic (multiple lines)
    # - Error handling
    # - Multiple transformations
    # - Need for documentation
  end

  def test_05_pipe_order_matters do
    # CONCEPT: Order Dependency and Data Flow
    #
    # The order of operations in a pipe chain matters because each
    # step transforms the data for the next step. Understanding this
    # helps avoid subtle bugs and design better pipelines.

    text = "elixir programming"

    # Order 1: split first, then capitalize
    result1 =
      text
      |> String.split(" ")
      |> Enum.map(&String.capitalize/1)

    # Order 2: capitalize first, then split
    result2 =
      text
      |> String.capitalize()
      |> String.split(" ")

    assert_equal(Enlightenment.__(), result1)

    assert_equal(Enlightenment.__(), result2)

    assert_equal(Enlightenment.__(), result1 == result2)

    # Order dependency analysis:
    #
    # Pipeline 1: "elixir programming" → ["elixir", "programming"] → ["Elixir", "Programming"]
    # Pipeline 2: "elixir programming" → "Elixir programming" → ["Elixir", "programming"]
    #
    # Key insight: Each step sees the result of the previous step
    # The data type and shape can change at each step
    #
    # Order considerations:
    #
    # 1. Data type compatibility:
    # "hello" |> String.split(" ") |> String.upcase()  # Error!
    # # split returns list, upcase expects string
    #
    # 2. Performance implications:
    # # Filter before expensive operations
    # data |> Enum.filter(&cheap_check/1) |> Enum.map(&expensive_transform/1)
    # # vs
    # data |> Enum.map(&expensive_transform/1) |> Enum.filter(&expensive_check/1)
    #
    # 3. Logic dependencies:
    # user_input
    # |> String.trim()           # Must clean first
    # |> String.downcase()       # Then normalize
    # |> validate_format()       # Then validate
    #
    # Common ordering patterns:
    #
    # Data cleaning pipeline:
    # raw_data
    # |> normalize_encoding()    # Fix encoding issues first
    # |> remove_whitespace()     # Clean whitespace
    # |> validate_format()       # Then validate structure
    # |> parse_fields()          # Finally parse content
    #
    # Collection processing pipeline:
    # items
    # |> Enum.filter(&valid?/1)     # Remove invalid first (reduce work)
    # |> Enum.map(&normalize/1)      # Then transform
    # |> Enum.sort_by(&(&1.priority)) # Then sort
    # |> Enum.take(10)               # Finally limit results
    #
    # Error-prone orderings to watch for:
    # - Parsing before cleaning
    # - Expensive operations before filtering
    # - Validation after transformation
    # - Sorting before filtering (unnecessary work)
  end

  def test_06_pipe_with_case do
    # CONCEPT: Control Flow Integration
    #
    # Pipes integrate seamlessly with Elixir's control flow constructs
    # like case, cond, and with. This enables sophisticated error
    # handling and branching within pipeline flows.

    # You can pipe into case statements
    result =
      {:ok, "success"}
      |> case do
        {:ok, message} -> "Got: #{message}"
        {:error, error} -> "Error: #{error}"
      end

    assert_equal(Enlightenment.__(), result)

    # Control flow patterns in pipes:
    #
    # Case statement piping:
    # data
    # |> fetch_data()
    # |> case do
    #   {:ok, result} -> process_success(result)
    #   {:error, reason} -> handle_error(reason)
    # end
    #
    # Cond statement piping:
    # user_input
    # |> String.trim()
    # |> cond do
    #   input == "" -> {:error, "empty input"}
    #   String.length(input) > 100 -> {:error, "too long"}
    #   true -> {:ok, input}
    # end
    #
    # If statement piping:
    # data
    # |> clean_data()
    # |> if valid?(data) do
    #   process_data(data)
    # else
    #   default_data()
    # end
    #
    # Advanced control flow patterns:
    #
    # Multi-step validation:
    # user_params
    # |> case do
    #   %{"email" => email, "password" => password} when email != "" and password != "" ->
    #     {:ok, {email, password}}
    #   _ ->
    #     {:error, "missing required fields"}
    # end
    # |> case do
    #   {:ok, {email, password}} -> authenticate(email, password)
    #   {:error, _} = error -> error
    # end
    #
    # Pattern matching in case:
    # response
    # |> Http.get()
    # |> case do
    #   {:ok, %{status: 200, body: body}} -> parse_json(body)
    #   {:ok, %{status: 404}} -> {:error, :not_found}
    #   {:ok, %{status: status}} -> {:error, {:http_error, status}}
    #   {:error, reason} -> {:error, {:network_error, reason}}
    # end
    #
    # Benefits of control flow piping:
    # ✅ Maintains left-to-right reading flow
    # ✅ Handles errors without breaking the pipeline
    # ✅ Enables complex branching logic
    # ✅ Integrates pattern matching naturally
    #
    # When to use:
    # - Error handling in pipelines
    # - Conditional processing
    # - Data validation flows
    # - Response processing
  end

  def test_07_pipe_with_with_statement do
    # CONCEPT: Railway-Oriented Programming with 'with'
    #
    # The 'with' statement creates elegant error-handling pipelines
    # that follow the "railway-oriented programming" pattern, where
    # success and failure flow along separate tracks.

    user_data = %{name: "Alice", email: "alice@example.com"}

    # Pipe into with statement for error handling
    result =
      user_data
      |> with {:ok, name} <- Map.fetch(user_data, :name),
              {:ok, email} <- Map.fetch(user_data, :email) do
        "User: #{name} <#{email}>"
      end

    assert_equal(Enlightenment.__(), result)

    # 'with' statement patterns in pipes:
    #
    # Basic with pattern:
    # data
    # |> with {:ok, step1} <- process_step1(data),
    #         {:ok, step2} <- process_step2(step1),
    #         {:ok, step3} <- process_step3(step2) do
    #   {:ok, step3}
    # end
    #
    # With error handling:
    # data
    # |> with {:ok, cleaned} <- clean_data(data),
    #         {:ok, validated} <- validate_data(cleaned),
    #         {:ok, processed} <- process_data(validated) do
    #   {:ok, processed}
    # else
    #   {:error, :invalid_format} -> {:error, "Data format is invalid"}
    #   {:error, :validation_failed} -> {:error, "Validation failed"}
    #   error -> error
    # end
    #
    # Railway-oriented programming concept:
    # Success track: data → clean → validate → process → result
    # Failure track: error ↘ ↘ ↘ → error handling
    #
    # Real-world example - user registration:
    # registration_params
    # |> with {:ok, email} <- validate_email(params[:email]),
    #         {:ok, password} <- validate_password(params[:password]),
    #         {:ok, user} <- create_user(email, password),
    #         {:ok, token} <- generate_token(user) do
    #   {:ok, %{user: user, token: token}}
    # else
    #   {:error, :invalid_email} -> {:error, "Invalid email format"}
    #   {:error, :weak_password} -> {:error, "Password too weak"}
    #   {:error, :user_exists} -> {:error, "User already exists"}
    #   {:error, :token_generation_failed} -> {:error, "Failed to generate token"}
    # end
    #
    # Benefits of with + pipes:
    # ✅ Clear success path
    # ✅ Early error returns
    # ✅ Pattern matching on each step
    # ✅ Readable error handling
    # ✅ No nested if/case statements
    #
    # When to use with in pipes:
    # - Multi-step operations with potential failures
    # - Data validation pipelines
    # - API processing workflows
    # - Resource acquisition patterns
    # - Complex business logic flows
  end

  def test_08_when_not_to_use_pipes do
    # CONCEPT: Pipe Operator Anti-Patterns
    #
    # While pipes are powerful, they're not always the best choice.
    # Understanding when NOT to use pipes helps write cleaner,
    # more maintainable code.

    # Don't use pipes for single operations - it's overkill
    bad_style = "hello" |> String.upcase()
    good_style = String.upcase("hello")

    assert_equal(Enlightenment.__(), bad_style == good_style)

    # Anti-patterns and better alternatives:
    #
    # 1. Single function calls (overkill):
    # ❌ value |> process()
    # ✅ process(value)
    #
    # 2. When intermediate values are needed:
    # ❌ Difficult with pipes
    # data |> step1() |> step2() |> step3()
    # # What if you need the result of step1 later?
    #
    # ✅ Clear with variables
    # step1_result = step1(data)
    # step2_result = step2(step1_result)
    # final_result = step3(step2_result)
    # # step1_result available for other uses
    #
    # 3. Complex branching logic:
    # ❌ Hard to follow
    # data
    # |> case do
    #   x when condition1 -> process1(x) |> case do
    #     y when condition2 -> process2(y)
    #     y -> process3(y)
    #   end
    #   x -> process4(x)
    # end
    #
    # ✅ Clearer with separate functions
    # defp handle_condition1(data) do
    #   case process1(data) do
    #     result when condition2 -> process2(result)
    #     result -> process3(result)
    #   end
    # end
    #
    # 4. Performance-critical sections:
    # ❌ Unnecessary function calls
    # numbers |> Enum.map(&(&1 + 1)) |> Enum.filter(&(&1 > 10))
    #
    # ✅ Combined operations when performance matters
    # for n <- numbers, n + 1 > 10, do: n + 1
    #
    # 5. When functions don't fit the pipe pattern:
    # ❌ Awkward parameter ordering
    # data |> some_function(config, opts, extra_param)
    # # If data isn't naturally the "primary" parameter
    #
    # ✅ Regular function call
    # some_function(config, data, opts, extra_param)
    #
    # Guidelines for pipe usage:
    #
    # Use pipes when:
    # ✅ 2+ transformation steps
    # ✅ Clear data flow
    # ✅ Functions designed for piping
    # ✅ Left-to-right reading improves clarity
    #
    # Avoid pipes when:
    # ❌ Single function calls
    # ❌ Intermediate results needed elsewhere
    # ❌ Complex branching obscures logic
    # ❌ Performance is critical and alternative is faster
    # ❌ Functions don't follow data-first pattern
  end

  def test_09_pipe_with_custom_functions do
    # CONCEPT: Designing Pipe-Friendly Functions
    #
    # Creating functions that work well with pipes requires following
    # specific design patterns. This promotes composability and
    # maintainability in functional programming.

    defmodule TextProcessor do
      def clean(text), do: String.trim(text)
      def normalize(text), do: String.downcase(text)
      def to_slug(text), do: String.replace(text, " ", "-")
    end

    result =
      "  Hello World Blog Post  "
      |> TextProcessor.clean()
      |> TextProcessor.normalize()
      |> TextProcessor.to_slug()

    assert_equal(Enlightenment.__(), result)

    # Pipe-friendly function design principles:
    #
    # 1. Data-first parameter ordering:
    # ✅ def process_user(user, options), do: ...
    # ❌ def process_user(options, user), do: ...
    #
    # 2. Consistent return types:
    # ✅ Always return the same type for chainability
    # def clean(text), do: String.trim(text)      # String → String
    # def validate(text), do: String.length(text) > 0 # String → Boolean
    #
    # 3. Single responsibility:
    # ✅ Each function does one thing well
    # def normalize_email(email) do
    #   email |> String.trim() |> String.downcase()
    # end
    #
    # 4. Descriptive names that read like actions:
    # ✅ user |> authenticate() |> authorize() |> log_activity()
    # ❌ user |> auth_check() |> perm_verify() |> activity_log()
    #
    # Advanced pipe-friendly patterns:
    #
    # Tap pattern (perform side effect, return original):
    # defmodule Pipeline do
    #   def tap(value, func) do
    #     func.(value)
    #     value
    #   end
    # end
    #
    # Usage:
    # data
    # |> process()
    # |> Pipeline.tap(&Logger.info("Processed: #{inspect(&1)}"))
    # |> save_to_db()
    #
    # Conditional processing:
    # defmodule Conditional do
    #   def when_true(value, condition, func) do
    #     if condition.(value), do: func.(value), else: value
    #   end
    # end
    #
    # data
    # |> clean()
    # |> Conditional.when_true(&valid?/1, &process_valid/1)
    # |> save()
    #
    # Error-aware pipelines:
    # defmodule SafePipe do
    #   def safe_call(value, func) do
    #     case value do
    #       {:ok, data} -> {:ok, func.(data)}
    #       {:error, _} = error -> error
    #     end
    #   end
    # end
    #
    # {:ok, data}
    # |> SafePipe.safe_call(&process1/1)
    # |> SafePipe.safe_call(&process2/1)
    #
    # Real-world example - user processing pipeline:
    # defmodule UserService do
    #   def validate_email(user), do: # validation logic
    #   def hash_password(user), do: # password hashing
    #   def set_defaults(user), do: # default values
    #   def save_to_db(user), do: # database persistence
    # end
    #
    # user_params
    # |> UserService.validate_email()
    # |> UserService.hash_password()
    # |> UserService.set_defaults()
    # |> UserService.save_to_db()
  end

  def test_10_pipe_debugging_trick do
    # CONCEPT: Pipeline Debugging and Introspection
    #
    # Pipes make debugging easier by allowing inspection at any step
    # in the transformation chain. This is crucial for understanding
    # data flow and diagnosing issues in complex pipelines.

    # You can insert IO.inspect anywhere in a pipe chain for debugging
    # (We'll simulate this without actually printing)

    result =
      [1, 2, 3, 4, 5]
      |> Enum.map(&(&1 * 2))
      # Simulating IO.inspect
      |> (fn list -> list end).()
      |> Enum.filter(&(&1 > 5))
      |> Enum.sum()

    assert_equal(Enlightenment.__(), result)


    # Debugging techniques in pipes:
    #
    # 1. IO.inspect for quick debugging:
    # data
    # |> process_step1()
    # |> IO.inspect(label: "After step1")  # Shows value and continues
    # |> process_step2()
    # |> IO.inspect(label: "After step2")
    # |> process_step3()
    #
    # 2. Tap pattern for side effects:
    # defp debug_tap(value, label) do
    #   IO.puts("#{label}: #{inspect(value)}")
    #   value
    # end
    #
    # data
    # |> process_step1()
    # |> debug_tap("After step1")
    # |> process_step2()
    #
    # 3. Anonymous function debugging:
    # data
    # |> step1()
    # |> (fn x ->
    #   IO.puts("Debug: #{inspect(x)}")
    #   x
    # end).()
    # |> step2()
    #
    # 4. Conditional debugging:
    # data
    # |> step1()
    # |> (fn x ->
    #   if Application.get_env(:app, :debug) do
    #     IO.inspect(x, label: "Debug point")
    #   else
    #     x
    #   end
    # end).()
    # |> step2()
    #
    # 5. Logger-based debugging:
    # require Logger
    #
    # data
    # |> step1()
    # |> (fn x -> Logger.debug("Pipeline debug: #{inspect(x)}"); x end).()
    # |> step2()
    #
    # Advanced debugging patterns:
    #
    # Breakpoint pattern:
    # defp breakpoint(value, condition \\ fn _ -> true end) do
    #   if condition.(value) do
    #     IEx.pry()  # Drop into debugger
    #   end
    #   value
    # end
    #
    # data |> step1() |> breakpoint(&(&1.status == :error)) |> step2()
    #
    # Performance debugging:
    # defp time_step(value, label) do
    #   start_time = :os.system_time(:millisecond)
    #   result = yield(value)  # Or just return value for simple timing
    #   end_time = :os.system_time(:millisecond)
    #   IO.puts("#{label} took #{end_time - start_time}ms")
    #   result
    # end
    #
    # Type debugging:
    # defp inspect_type(value) do
    #   IO.puts("Type: #{inspect(value.__struct__ || :not_struct)}")
    #   IO.puts("Value: #{inspect(value)}")
    #   value
    # end
    #
    # The key insight: Pipes make it trivial to inspect data at any
    # transformation step without restructuring your code.
  end

  def test_11_pipe_alternatives do
    # CONCEPT: Comparing Pipeline Styles
    #
    # Understanding different ways to write the same logic helps
    # appreciate the benefits of pipes and choose the right approach
    # for different situations.

    # These are all equivalent:

    # Nested function calls (hard to read)
    result1 = Enum.sum(Enum.filter(Enum.map([1, 2, 3, 4], &(&1 * 2)), &(&1 > 3)))

    # Intermediate variables (verbose)
    doubled = Enum.map([1, 2, 3, 4], &(&1 * 2))
    filtered = Enum.filter(doubled, &(&1 > 3))
    result2 = Enum.sum(filtered)

    # Pipe operator (readable and concise)
    result3 =
      [1, 2, 3, 4]
      |> Enum.map(&(&1 * 2))
      |> Enum.filter(&(&1 > 3))
      |> Enum.sum()

    assert_equal(Enlightenment.__(), result1 == result2)

    assert_equal(Enlightenment.__(), result2 == result3)

    assert_equal(Enlightenment.__(), result3)

    # Style comparison analysis:
    #
    # 1. Nested function calls:
    # ❌ Hard to read (inside-out)
    # ❌ Difficult to modify (must find the right level)
    # ❌ Error-prone (easy to misplace parentheses)
    # ✅ Compact (single expression)
    # ✅ No intermediate variables
    #
    # 2. Intermediate variables:
    # ✅ Easy to debug (can inspect each step)
    # ✅ Clear data flow
    # ✅ Can reuse intermediate results
    # ❌ Verbose (many variable declarations)
    # ❌ Naming overhead (need meaningful names)
    # ❌ Scope pollution (variables in scope longer than needed)
    #
    # 3. Pipe operator:
    # ✅ Readable left-to-right flow
    # ✅ Easy to modify (add/remove/reorder steps)
    # ✅ No naming overhead
    # ✅ Clear data transformation intent
    # ❌ Hard to reuse intermediate results
    # ❌ Can be overused (single operations)
    #
    # When to choose each style:
    #
    # Nested calls:
    # - Very simple operations (2-3 functions max)
    # - Performance critical (minimal overhead)
    # - Mathematical expressions
    #
    # Intermediate variables:
    # - Complex debugging needed
    # - Intermediate results reused
    # - Teaching/documentation purposes
    # - Multi-step validation
    #
    # Pipe operator:
    # - Data transformation pipelines
    # - Functional programming style
    # - Clear sequential processing
    # - Most Elixir code (idiomatic)
    #
    # Hybrid approaches:
    # Sometimes combining styles works best:
    #
    # # Break complex pipe into phases
    # cleaned_data = raw_data |> clean() |> validate()
    # processed_data = cleaned_data |> transform() |> enrich()
    # final_result = processed_data |> format() |> save()
    #
    # # Use pipes within function arguments
    # some_function(
    #   data |> prepare(),
    #   options |> normalize()
    # )
  end

  def test_12_pipe_with_then do
    # CONCEPT: The then/2 Function for Complex Pipeline Logic
    #
    # Sometimes pipelines need more complex logic than simple function
    # calls. The then/2 function provides a way to include conditional
    # logic and complex transformations within a pipeline.

    # Sometimes you need more complex logic in a pipe
    # Use then/2 for this

    result =
      "hello"
      |> String.upcase()
      |> then(fn str ->
        if String.length(str) > 3 do
          str <> " WORLD"
        else
          str
        end
      end)

    assert_equal(Enlightenment.__(), result)

    # then/2 patterns and use cases:
    #
    # Basic then/2 usage:
    # data |> then(fn x -> complex_logic(x) end)
    #
    # Conditional transformations:
    # user
    # |> load_profile()
    # |> then(fn user ->
    #   if user.premium? do
    #     add_premium_features(user)
    #   else
    #     user
    #   end
    # end)
    #
    # Complex calculations:
    # numbers
    # |> Enum.sum()
    # |> then(fn sum ->
    #   average = sum / length(numbers)
    #   standard_deviation = calculate_std_dev(numbers, average)
    #   %{sum: sum, average: average, std_dev: standard_deviation}
    # end)
    #
    # Error handling within pipes:
    # data
    # |> process_step1()
    # |> then(fn
    #   {:ok, result} -> {:ok, process_step2(result)}
    #   {:error, _} = error -> error
    # end)
    #
    # Multi-value operations:
    # config
    # |> load_settings()
    # |> then(fn settings ->
    #   {db_config, cache_config} = split_config(settings)
    #   %{
    #     database: setup_database(db_config),
    #     cache: setup_cache(cache_config)
    #   }
    # end)
    #
    # Alternative patterns for complex logic:
    #
    # 1. Extract to private function:
    # defp apply_conditional_logic(str) do
    #   if String.length(str) > 3 do
    #     str <> " WORLD"
    #   else
    #     str
    #   end
    # end
    #
    # result = "hello" |> String.upcase() |> apply_conditional_logic()
    #
    # 2. Use case within pipe:
    # result = "hello"
    # |> String.upcase()
    # |> case do
    #   str when byte_size(str) > 3 -> str <> " WORLD"
    #   str -> str
    # end
    #
    # 3. Use cond within pipe:
    # result = data
    # |> normalize()
    # |> cond do
    #   data.type == :premium -> add_premium_features(data)
    #   data.type == :basic -> add_basic_features(data)
    #   true -> data
    # end
    #
    # When to use then/2:
    # ✅ Complex conditional logic within pipeline
    # ✅ Multi-step calculations that produce single result
    # ✅ Temporary variables needed for calculation
    # ✅ Pattern matching with multiple clauses
    #
    # When to avoid then/2:
    # ❌ Simple conditional (use case instead)
    # ❌ Logic that could be a separate function
    # ❌ Very complex logic (extract to function)
    # ❌ When readability suffers
  end

  def test_13_pipe_readability_example do
    # CONCEPT: Real-World Pipeline Design
    #
    # This example demonstrates how pipes enable writing expressive,
    # maintainable code that clearly communicates intent while handling
    # real-world complexity like validation and error handling.

    # Real-world example: processing user input
    user_input = "  Alice@EXAMPLE.com  "

    processed_email =
      user_input
      # Remove whitespace
      |> String.trim()
      # Normalize case
      |> String.downcase()
      # Split into parts
      |> String.split("@")
      # Validate format
      |> case do
        [username, domain] when username != "" and domain != "" ->
          {:ok, "#{username}@#{domain}"}

        _ ->
          {:error, "Invalid email format"}
      end

    assert_equal(Enlightenment.__(), processed_email)

    # Real-world pipeline design principles:
    #
    # 1. Tell a story with your pipeline:
    # Each step should read like a sentence describing what happens
    # "Take input, trim whitespace, normalize case, split into parts, validate format"
    #
    # 2. Layer by abstraction level:
    # Start with data cleaning (low-level)
    # Move to normalization (medium-level)
    # End with validation/business logic (high-level)
    #
    # 3. Handle errors at the right level:
    # Clean data first, then validate
    # Use pattern matching for structure validation
    # Return clear error messages
    #
    # Extended real-world example - user registration:
    #
    # defmodule UserRegistration do
    #   def process_registration(params) do
    #     params
    #     |> extract_user_data()           # Parse input
    #     |> validate_required_fields()    # Check required data
    #     |> normalize_email()             # Clean email
    #     |> validate_email_format()       # Check email format
    #     |> hash_password()               # Security
    #     |> check_user_exists()           # Business rule
    #     |> create_user_record()          # Persistence
    #     |> send_welcome_email()          # Side effect
    #     |> format_response()             # API response
    #   end
    #
    #   defp extract_user_data(params) do
    #     case params do
    #       %{"email" => email, "password" => password, "name" => name} ->
    #         {:ok, %{email: email, password: password, name: name}}
    #       _ ->
    #         {:error, "Missing required fields"}
    #     end
    #   end
    #
    #   defp validate_required_fields({:ok, %{email: "", password: _, name: _}}) do
    #     {:error, "Email cannot be empty"}
    #   end
    #   defp validate_required_fields({:ok, data}), do: {:ok, data}
    #   defp validate_required_fields(error), do: error
    #
    #   # ... more pipeline functions
    # end
    #
    # Benefits of this approach:
    # ✅ Each function has single responsibility
    # ✅ Easy to test individual steps
    # ✅ Clear error handling at each level
    # ✅ Easy to add/remove/modify steps
    # ✅ Self-documenting business process
    # ✅ Functional programming benefits (immutability, composability)
    #
    # API processing pipeline example:
    # def process_api_request(request) do
    #   request
    #   |> authenticate_user()           # Security
    #   |> rate_limit_check()           # Protection
    #   |> parse_request_body()         # Data parsing
    #   |> validate_business_rules()    # Domain validation
    #   |> execute_business_logic()     # Core functionality
    #   |> format_response()            # Output formatting
    #   |> log_request()                # Observability
    # end
    #
    # Each function returns {:ok, data} | {:error, reason} for
    # consistent error handling throughout the pipeline.
  end
end
