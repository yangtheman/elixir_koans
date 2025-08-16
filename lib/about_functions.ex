defmodule AboutFunctions do
  @moduledoc """
  Functions are first-class citizens in Elixir.
  There are anonymous functions and named functions.

  ## Understanding Functions in Elixir

  Functions are the primary building blocks of Elixir programs. Unlike object-oriented
  languages where methods belong to classes, Elixir functions belong to modules and
  are the primary means of organizing and executing code.

  ## Types of Functions

  1. **Anonymous Functions**: Created with `fn` or `&`, can be stored in variables
  2. **Named Functions**: Defined with `def` inside modules, have names and arity
  3. **Private Functions**: Defined with `defp`, only accessible within the module
  4. **Function Captures**: References to existing functions using `&`

  ## Key Concepts

  - **First-class**: Functions can be stored, passed, and returned like any value
  - **Immutability**: Functions don't modify data, they transform it
  - **Pattern Matching**: Function definitions can pattern match on arguments
  - **Guards**: Additional conditions on function arguments
  - **Arity**: Functions are identified by name AND number of parameters
  - **Tail Recursion**: Optimized recursive calls that don't grow the stack

  ## Functional Programming Principles

  - **Pure Functions**: Same input always produces same output, no side effects
  - **Higher-order Functions**: Functions that take or return other functions
  - **Function Composition**: Combining simple functions to create complex behavior
  - **Recursion**: Functions calling themselves, the functional alternative to loops
  - **Closures**: Anonymous functions capturing variables from their environment

  ## Performance Considerations

  - Named functions are slightly faster than anonymous functions
  - Tail-recursive functions are optimized by the compiler
  - Pattern matching in function heads is very efficient
  - Function calls have minimal overhead in Elixir/Erlang
  """

  import Enlightenment

  def test_01_anonymous_functions do
    # CONCEPT: Anonymous Functions - Functions as Values
    #
    # Anonymous functions are values that can be created, stored in variables,
    # passed as arguments, and called later. They're essential for functional
    # programming patterns and make code more flexible and composable.

    # Create an anonymous function with fn/end syntax
    add = fn x, y -> x + y end

    # Call anonymous functions with .() syntax
    result = add.(3, 4)
    assert_equal(Enlightenment.__(), result)

    # Anonymous functions are values:
    # - Can be stored in variables
    # - Can be passed to other functions
    # - Can be returned from functions
    # - Have their own scope (closures)
    #
    # The .() syntax distinguishes anonymous function calls from named function calls
  end

  def test_02_anonymous_function_shorthand do
    # CONCEPT: Function Shorthand Syntax (&)
    #
    # For simple anonymous functions, Elixir provides shorthand syntax using &.
    # This makes code more concise, especially when passing functions to
    # higher-order functions like Enum.map/2.

    # Shorthand for simple transformations
    # Equivalent to: fn x -> x * 2 end
    double = &(&1 * 2)
    assert_equal(Enlightenment.__(), double.(5))

    # Multiple parameters use &1, &2, &3, etc.
    # Equivalent to: fn x, y -> x * y end
    multiply = &(&1 * &2)
    assert_equal(Enlightenment.__(), multiply.(3, 4))

    # When to use shorthand:
    # ✅ Simple transformations: &(&1 + 1)
    # ✅ Single operations: &String.upcase/1
    # ❌ Complex logic: use full fn syntax for readability
    # ❌ Multiple expressions: fn syntax is clearer
  end

  def test_03_capturing_existing_functions do
    # CONCEPT: Function Capture - Referencing Existing Functions
    #
    # The & operator can capture references to existing functions, allowing
    # you to pass them as arguments without wrapping in anonymous functions.
    # This is more efficient and often more readable.

    # Capture existing function with &FunctionName/arity
    string_length = &String.length/1
    assert_equal(Enlightenment.__(), string_length.("Hello"))

    # Capture Erlang functions (from :module)
    math_sqrt = &:math.sqrt/1
    assert_equal(Enlightenment.__(), math_sqrt.(16))

    # Function capture advantages:
    # - More efficient than wrapping: &String.length/1 vs fn s -> String.length(s) end
    # - Clearer intent: shows you're using existing function
    # - Less verbose: shorter syntax
    #
    # Common pattern: Enum.map(strings, &String.length/1)
  end

  def test_04_functions_as_arguments do
    # CONCEPT: Higher-Order Functions - Functions as Parameters
    #
    # Functions can be passed as arguments to other functions, enabling
    # powerful abstractions and code reuse. This is a cornerstone of
    # functional programming and makes Elixir very expressive.

    numbers = [1, 2, 3, 4, 5]

    # Pass anonymous function to Enum.map/2
    doubled = Enum.map(numbers, fn x -> x * 2 end)
    assert_equal(Enlightenment.__(), doubled)

    # Using shorthand syntax - more concise
    tripled = Enum.map(numbers, &(&1 * 3))
    assert_equal(Enlightenment.__(), tripled)

    # Higher-order functions enable:
    # - Generic algorithms: Enum.map, Enum.filter, Enum.reduce
    # - Strategy pattern: pass different behaviors
    # - Event handling: pass callback functions
    # - Pipelines: chain transformations together
  end

  def test_05_named_functions_in_modules do
    # CONCEPT: Named Functions - Organized Code in Modules
    #
    # Named functions are defined inside modules with `def` and provide
    # the primary way to organize functionality. They have names, can
    # be documented, and are the building blocks of Elixir applications.

    defmodule Calculator do
      # Single-line function with do:
      def add(x, y), do: x + y

      # Multi-line function with do/end block
      def subtract(x, y) do
        x - y
      end
    end

    assert_equal(Enlightenment.__(), Calculator.add(10, 5))

    assert_equal(Enlightenment.__(), Calculator.subtract(10, 5))

    # Named functions provide:
    # - Organization: group related functions in modules
    # - Documentation: @doc attributes, @spec type annotations
    # - Public API: clear interface for module users
    # - Testability: easy to test individual functions
  end

  def test_06_function_arity do
    # CONCEPT: Function Arity - Functions Distinguished by Parameter Count
    #
    # In Elixir, functions are uniquely identified by their name AND arity
    # (number of parameters). This allows multiple functions with the same
    # name but different parameter counts, each handling different cases.

    defmodule Greeter do
      # hello/0
      def hello(), do: "Hello, World!"
      # hello/1
      def hello(name), do: "Hello, #{name}!"
      # hello/2
      def hello(first, last), do: "Hello, #{first} #{last}!"
    end

    # These are three completely different functions
    assert_equal(Enlightenment.__(), Greeter.hello())

    assert_equal(Enlightenment.__(), Greeter.hello("Alice"))

    assert_equal(Enlightenment.__(), Greeter.hello("Bob", "Smith"))

    # Arity enables:
    # - Overloading: different behavior based on parameter count
    # - Progressive complexity: simple cases with fewer params
    # - Clear documentation: hello/1 vs hello/2 are distinct
  end

  def test_07_default_parameters do
    # CONCEPT: Default Parameters - Optional Arguments
    #
    # Default parameters allow functions to be called with fewer arguments
    # by providing sensible defaults. This creates flexible APIs without
    # requiring multiple function definitions.

    defmodule DefaultExample do
      def greet(name, greeting \\ "Hello") do
        "#{greeting}, #{name}!"
      end
    end

    # Call with default parameter
    assert_equal(Enlightenment.__(), DefaultExample.greet("Alice"))

    # Override the default
    assert_equal(Enlightenment.__(), DefaultExample.greet("Bob", "Hi"))

    # Default parameters create multiple arities:
    # greet(name, greeting \\ "Hello") creates both greet/1 and greet/2
    #
    # Best practices:
    # - Put defaults on rightmost parameters
    # - Use sensible defaults that work for most cases
    # - Document what the defaults are
  end

  def test_08_pattern_matching_in_function_definitions do
    # CONCEPT: Pattern Matching Function Heads - Dispatch by Data Shape
    #
    # Function definitions can pattern match on their arguments, allowing
    # elegant dispatching based on data structure rather than conditional logic.
    # This makes code more declarative and easier to understand.

    defmodule StatusHandler do
      # Pattern match on tuple structure
      def handle({:ok, data}), do: "Success: #{data}"
      def handle({:error, reason}), do: "Error: #{reason}"
      # Catch-all pattern
      def handle(_), do: "Unknown status"
    end

    assert_equal(Enlightenment.__(), StatusHandler.handle({:ok, "all good"}))

    assert_equal(Enlightenment.__(), StatusHandler.handle({:error, "something broke"}))

    assert_equal(Enlightenment.__(), StatusHandler.handle(:unknown))

    # Pattern matching in functions enables:
    # - Clean error handling: separate cases for {:ok, _} and {:error, _}
    # - Recursive algorithms: base case and recursive case
    # - Protocol implementation: different behavior for different data types
  end

  def test_09_guards_in_functions do
    # CONCEPT: Guards - Additional Conditions on Function Arguments
    #
    # Guards add boolean conditions to function pattern matching, allowing
    # more specific function dispatch. They can check types, values, and
    # simple computations to choose the right function clause.

    defmodule NumberClassifier do
      def classify(x) when x > 0, do: "positive"
      def classify(x) when x < 0, do: "negative"
      # Literal match, no guard needed
      def classify(0), do: "zero"
    end

    assert_equal(Enlightenment.__(), NumberClassifier.classify(5))

    assert_equal(Enlightenment.__(), NumberClassifier.classify(-3))

    assert_equal(Enlightenment.__(), NumberClassifier.classify(0))

    # Guards can use:
    # - Comparisons: ==, !=, <, >, <=, >=
    # - Type checks: is_integer, is_list, is_binary
    # - Boolean operators: and, or, not
    # - Math: +, -, *, div, rem
    # - Some built-ins: length, byte_size, map_size
  end

  def test_10_recursive_functions do
    # CONCEPT: Recursion - Functions Calling Themselves
    #
    # Recursion is the functional programming alternative to loops.
    # Instead of mutating variables in loops, recursive functions
    # process data by breaking it into smaller pieces.

    defmodule ListLength do
      # Base case: empty list has length 0
      def count([]), do: 0

      # Recursive case: 1 + length of tail
      def count([_head | tail]), do: 1 + count(tail)
    end

    assert_equal(Enlightenment.__(), ListLength.count([]))

    assert_equal(Enlightenment.__(), ListLength.count([1, 2, 3, 4]))

    # Recursive pattern:
    # 1. Base case(s): when to stop recursing
    # 2. Recursive case: process part, recurse on rest
    # 3. Combine results
    #
    # Common recursive patterns:
    # - List processing: [head | tail] pattern
    # - Tree traversal: recurse on children
    # - Divide and conquer: split problem, solve parts
  end

  def test_11_tail_recursion do
    # CONCEPT: Tail Recursion - Optimized Recursive Calls
    #
    # Tail recursion is when the recursive call is the last operation
    # in the function. The compiler optimizes this into a loop, preventing
    # stack overflow and making it as efficient as iterative solutions.

    defmodule TailRecursive do
      # Public function with default accumulator
      def sum(list), do: sum(list, 0)

      # Private tail-recursive helper with accumulator
      # Base case: return accumulator
      defp sum([], acc), do: acc
      # Tail recursive
      defp sum([head | tail], acc), do: sum(tail, head + acc)
    end

    assert_equal(Enlightenment.__(), TailRecursive.sum([1, 2, 3, 4, 5]))

    # Tail recursion optimization:
    # - No new stack frame per call
    # - Can handle very large lists without stack overflow
    # - As efficient as loops in imperative languages
    #
    # Pattern: Use accumulator to carry state, return it in base case
    # The recursive call must be the LAST operation (in tail position)
  end

  def test_12_private_functions do
    # CONCEPT: Private Functions - Internal Module Implementation
    #
    # Private functions (defined with `defp`) are only accessible within
    # the module where they're defined. They're used for implementation
    # details that shouldn't be part of the public API.

    defmodule PrivateExample do
      # Public function - part of module's API
      def public_function(x), do: private_function(x) * 2

      # Private function - implementation detail
      defp private_function(x), do: x + 1
    end

    assert_equal(Enlightenment.__(), PrivateExample.public_function(5))

    # Private functions can't be called from outside
    assert_raise UndefinedFunctionError, fn ->
      PrivateExample.private_function(5)
    end

    # Use private functions for:
    # - Helper functions used only within the module
    # - Implementation details that might change
    # - Breaking complex functions into smaller pieces
    # - Tail-recursive helpers with accumulators
  end

  def test_13_closures do
    # CONCEPT: Closures - Anonymous Functions Capturing Environment
    #
    # Anonymous functions can "close over" (capture) variables from their
    # surrounding environment. The captured variables become part of the
    # function, allowing it to use them even after the original scope ends.

    # Variable in outer scope
    multiplier = 3

    # Anonymous function captures 'multiplier'
    multiply_by_three = fn x -> x * multiplier end
    assert_equal(Enlightenment.__(), multiply_by_three.(4))

    # Closures capture values at creation time
    counter = 5
    increment = fn -> counter + 1 end

    # Changing counter after closure creation doesn't affect it
    counter = 10
    assert_equal(Enlightenment.__(), increment.())

    # Closures enable:
    # - Parameterized functions: create_multiplier(n) -> fn x -> x * n end
    # - Event callbacks with context
    # - Functional programming patterns like partial application
  end

  def test_14_higher_order_functions do
    # CONCEPT: Higher-Order Functions - Functions Operating on Functions
    #
    # Higher-order functions either take functions as arguments or return
    # functions as results. They enable powerful abstractions and are
    # fundamental to functional programming.

    defmodule HigherOrder do
      # Takes a function and applies it twice
      def apply_twice(fun, value) do
        fun.(fun.(value))
      end

      # Returns a function (closure)
      def create_adder(n) do
        # Captures 'n' from environment
        fn x -> x + n end
      end
    end

    double = fn x -> x * 2 end
    assert_equal(Enlightenment.__(), HigherOrder.apply_twice(double, 3))

    # Function returns another function
    add_five = HigherOrder.create_adder(5)
    assert_equal(Enlightenment.__(), add_five.(10))

    # Higher-order functions enable:
    # - Generic algorithms: map, filter, reduce
    # - Function factories: create specialized functions
    # - Decorators: wrap functions with additional behavior
    # - Strategy pattern: pass different implementations
  end

  def test_15_pipe_operator_with_functions do
    # CONCEPT: Pipe Operator - Chaining Function Calls
    #
    # The |> operator takes the result of the expression on its left and
    # passes it as the first argument to the function on its right.
    # This creates readable data transformation pipelines.

    result =
      "hello world"
      # "HELLO WORLD"
      |> String.upcase()
      # ["HELLO", "WORLD"]
      |> String.split()
      # ["WORLD", "HELLO"]
      |> Enum.reverse()
      # "WORLD HELLO"
      |> Enum.join(" ")

    assert_equal(Enlightenment.__(), result)

    # Pipe operator advantages:
    # - Left-to-right reading: matches natural thought process
    # - Avoids nested function calls: f(g(h(x))) becomes x |> h() |> g() |> f()
    # - Easy to add/remove steps in pipeline
    # - Clear data flow: input -> transform -> transform -> output
    #
    # The pipe is just syntactic sugar: x |> f(y) becomes f(x, y)
  end

  def test_16_function_composition do
    # CONCEPT: Function Composition - Building Complex from Simple
    #
    # Function composition is combining simple functions to create more
    # complex behavior. This promotes code reuse, testability, and
    # understanding by breaking complex operations into simple steps.

    # Compose multiple transformations into one function
    transform = fn text ->
      text
      # Remove whitespace
      |> String.trim()
      # Convert to lowercase
      |> String.downcase()
      # Replace spaces with underscores
      |> String.replace(" ", "_")
    end

    assert_equal(Enlightenment.__(), transform.("  Hello World  "))

    # Composition benefits:
    # - Modularity: each function has one responsibility
    # - Testability: test each step independently
    # - Reusability: compose functions in different ways
    # - Readability: clear sequence of transformations
    #
    # Alternative style using separate functions:
    # text |> clean() |> normalize() |> slugify()
  end

  def test_17_function_pattern_matching_with_multiple_clauses do
    # CONCEPT: Multiple Function Clauses - Elegant Branching Logic
    #
    # Instead of if/case statements inside functions, you can define multiple
    # clauses of the same function that pattern match different inputs.
    # Elixir tries each clause in order until one matches.

    defmodule Fibonacci do
      # Base cases
      def fib(0), do: 0
      def fib(1), do: 1

      # Recursive case with guard
      def fib(n) when n > 1, do: fib(n - 1) + fib(n - 2)

      # Error case
      def fib(n) when n < 0, do: {:error, "Negative numbers not supported"}
    end

    assert_equal(Enlightenment.__(), Fibonacci.fib(0))

    assert_equal(Enlightenment.__(), Fibonacci.fib(6))

    assert_equal(Enlightenment.__(), Fibonacci.fib(-1))

    # Multiple clauses provide:
    # - Clear separation of different cases
    # - No nested conditionals
    # - Pattern-based dispatch
    # - Easy to add new cases
  end
end
