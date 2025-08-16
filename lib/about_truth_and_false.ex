defmodule AboutTruthAndFalse do
  @moduledoc """
  Elixir has a clear concept of truthiness.
  Only nil and false are falsy - everything else is truthy.

  ## Understanding Truth in Elixir

  Elixir's approach to truthiness is remarkably simple and consistent compared
  to many other languages. This simplicity eliminates common programming errors
  and makes boolean logic predictable and reliable.

  ## Truthiness Rules

  **Falsy values (only 2):**
  - `nil` - represents absence/nothing
  - `false` - explicit boolean false

  **Truthy values (everything else):**
  - `true` - explicit boolean true
  - All numbers (including 0)
  - All strings (including "")
  - All atoms (except nil and false)
  - All collections (including empty ones)
  - All data structures

  ## Philosophical Design

  This design reflects functional programming principles:
  - **Explicit over implicit**: If something exists, it's true
  - **Predictable behavior**: No surprising conversions
  - **Safe defaults**: Empty collections are still collections
  - **Clear intent**: Use explicit boolean operations when needed

  ## Comparison with Other Languages

  Unlike JavaScript, Python, Ruby, or C where many values are falsy:
  - Elixir: Only `nil` and `false` are falsy
  - JavaScript: `0, "", null, undefined, NaN, false` are falsy
  - Python: `0, "", [], {}, None, False` are falsy
  - Ruby: Only `nil` and `false` are falsy (similar to Elixir)

  ## Boolean Operators

  Elixir provides both strict and relaxed boolean operators:

  **Strict operators** (require booleans):
  - `and`, `or`, `not` - for pure boolean logic

  **Relaxed operators** (work with any values):
  - `&&`, `||`, `!` - for general truthiness testing

  ## Pattern Matching with Booleans

  Booleans work naturally with pattern matching:
  ```elixir
  case api_call() do
    {:ok, true} -> "Success and enabled"
    {:ok, false} -> "Success but disabled"
    {:error, _} -> "Failed"
  end
  ```

  ## Common Patterns

  **Safe navigation:**
  ```elixir
  user && user.name && user.name.first
  ```

  **Default values:**
  ```elixir
  name = user_name || "Anonymous"
  ```

  **Guards with truthiness:**
  ```elixir
  def process(data) when not is_nil(data), do: transform(data)
  ```
  """

  import Enlightenment

  # Helper functions for guard demonstrations
  def classify(value) when is_nil(value), do: :nil_value
  def classify(value) when value == false, do: :false_value
  def classify(value) when value == true, do: :true_value
  def classify(_), do: :other_value

  # Helper function for truthiness comparison
  defp both_truthy?(a, b) do
    !!a == !!b
  end

  def test_01_true_is_treated_as_true do
    # CONCEPT: Boolean True Value
    #
    # The atom :true (displayed as true) represents boolean truth in Elixir.
    # It's a fundamental value used throughout the language for boolean
    # operations, conditionals, and logical expressions.

    assert_equal(Enlightenment.__(), true)

    # Important notes about true:
    # - true is actually the atom :true
    # - It's a literal value, not a variable
    # - Used in if/unless, case, guards, boolean operators
    # - Pattern matchable like any other atom
    #
    # Example usage:
    # if some_condition(), do: true, else: false
    # case validate(data) do
    #   true -> proceed()
    #   false -> handle_error()
    # end
  end

  def test_02_false_is_treated_as_false do
    # CONCEPT: Boolean False Value
    #
    # The atom :false (displayed as false) represents boolean falsehood.
    # Along with nil, it's one of only two values in Elixir that evaluate
    # to false in boolean contexts.

    assert_equal(Enlightenment.__(), false)

    # Characteristics of false:
    # - false is actually the atom :false
    # - One of only two falsy values in Elixir
    # - Used to explicitly represent negative boolean state
    # - Different from nil (which represents absence)
    #
    # When to use false vs nil:
    # - false: explicit boolean negative ("No, this is disabled")
    # - nil: absence or unknown ("This value doesn't exist")
  end

  def test_03_nil_is_treated_as_false do
    # CONCEPT: Nil as Falsy Value
    #
    # nil represents absence, nothing, or unknown state. It's the only
    # non-boolean value that is falsy in Elixir, making it perfect for
    # representing optional or missing data.

    assert_equal(Enlightenment.__(), nil == false)

    # But nil is falsy in boolean contexts
    result =
      if nil do
        "this won't execute"
      else
        "this will execute"
      end

    assert_equal(Enlightenment.__(), result)

    # nil characteristics:
    # - Represents absence of value
    # - Falsy but not equal to false
    # - Default return value for many functions
    # - Used extensively in pattern matching
    # - Safe to use in boolean contexts
    #
    # Common nil patterns:
    # - Map.get(map, :missing_key)  # Returns nil
    # - Enum.find(list, fn x -> x > 10 end)  # nil if not found
    # - Optional function parameters with default nil
  end

  def test_04_everything_else_is_treated_as_true do
    # CONCEPT: Everything Else is Truthy
    #
    # In Elixir, all values except nil and false are truthy. This includes
    # values that might be falsy in other languages like 0, empty strings,
    # and empty collections. This design promotes explicit programming.

    # Numbers (including zero) are truthy
    assert_equal(Enlightenment.__(), !!0)

    assert_equal(Enlightenment.__(), !!(-1))

    # Empty string is truthy
    assert_equal(Enlightenment.__(), !!"")

    # Empty collections are truthy
    assert_equal(Enlightenment.__(), !![])

    assert_equal(Enlightenment.__(), !!%{})

    # Atoms are truthy (except nil and false)
    assert_equal(Enlightenment.__(), !!:error)

    # Why everything else is truthy:
    # - Eliminates confusion about "emptiness" vs "falseness"
    # - Makes code more explicit and predictable
    # - Empty collections still exist (they're not nothing)
    # - Zero is a valid number (not absence of number)
    # - Forces developers to be explicit about their conditions
    #
    # This means you should explicitly check for what you care about:
    # - Use Enum.empty?(list) instead of relying on falsy empty list
    # - Use String.length(str) == 0 instead of relying on falsy empty string
    # - Use is_nil(value) to explicitly check for nil
  end

  def test_05_logical_and_operator do
    # CONCEPT: Logical AND - Both Must be Truthy
    #
    # The && operator returns the first falsy value it encounters,
    # or the last value if all are truthy. This makes it perfect for
    # chaining conditions and providing safe navigation patterns.

    # Both true
    assert_equal(Enlightenment.__(), true && true)

    # First false
    assert_equal(Enlightenment.__(), false && true)

    # Second false
    assert_equal(Enlightenment.__(), true && false)

    # Both false
    assert_equal(Enlightenment.__(), false && false)

    # With non-boolean values - returns first falsy or last truthy
    assert_equal(Enlightenment.__(), nil && "hello")

    assert_equal(Enlightenment.__(), "hello" && "world")

    # Practical && patterns:
    #
    # Safe navigation:
    # user && user.profile && user.profile.name
    #
    # Conditional assignment:
    # enabled && start_service()
    #
    # Validation chains:
    # valid_email?(email) && valid_password?(password) && create_user()
    #
    # Short-circuit evaluation prevents errors:
    # user && user.admin?  # Won't call admin? if user is nil
  end

  def test_06_logical_or_operator do
    # CONCEPT: Logical OR - First Truthy or Last Value
    #
    # The || operator returns the first truthy value it encounters,
    # or the last value if all are falsy. This makes it excellent for
    # providing default values and fallback chains.

    # First true
    assert_equal(Enlightenment.__(), true || false)

    # Second true
    assert_equal(Enlightenment.__(), false || true)

    # Both true
    assert_equal(Enlightenment.__(), true || true)

    # Both false
    assert_equal(Enlightenment.__(), false || false)

    # With non-boolean values - returns first truthy or last value
    assert_equal(Enlightenment.__(), nil || "default")

    assert_equal(Enlightenment.__(), "first" || "second")

    # Practical || patterns:
    #
    # Default values:
    # name = user_name || "Anonymous"
    # port = config_port || 4000
    #
    # Configuration cascading:
    # setting = user_pref || env_var || app_default
    #
    # Error recovery:
    # result = primary_service() || backup_service() || {:error, :all_failed}
    #
    # Nil-safe operations:
    # title = article.title || article.slug || "Untitled"
  end

  def test_07_logical_not_operator do
    # CONCEPT: Logical NOT - Truthiness Inversion
    #
    # The ! operator returns true for falsy values and false for truthy values.
    # It's useful for negating conditions and converting values to explicit booleans.

    # Negating booleans
    assert_equal(Enlightenment.__(), !true)

    assert_equal(Enlightenment.__(), !false)

    # Negating falsy values
    assert_equal(Enlightenment.__(), !nil)

    # Negating truthy values
    assert_equal(Enlightenment.__(), !"hello")

    assert_equal(Enlightenment.__(), ![1, 2, 3])

    # Double negation converts to boolean
    assert_equal(Enlightenment.__(), !!"anything")

    assert_equal(Enlightenment.__(), !!nil)

    # Practical ! patterns:
    #
    # Boolean conversion:
    # has_items = !!items  # Convert to true/false
    #
    # Negating conditions:
    # if !user.admin?, do: redirect_to_home()
    #
    # Validation:
    # unless !valid?(data), do: process(data)  # Guard against invalid
    #
    # Empty checking (be explicit):
    # if !Enum.empty?(list), do: process_items(list)
  end

  def test_08_strict_boolean_operators do
    # CONCEPT: Strict vs Relaxed Boolean Operators
    #
    # Elixir provides two sets of boolean operators:
    # - Strict (and, or, not) require boolean operands
    # - Relaxed (&&, ||, !) work with any values using truthiness

    # Strict operators require booleans
    assert_equal(Enlightenment.__(), true and false)

    assert_equal(Enlightenment.__(), true or false)

    assert_equal(Enlightenment.__(), not true)

    # These would raise BadBooleanError:
    # "hello" and "world"  # ArgumentError
    # nil or "default"     # ArgumentError
    # not "something"      # ArgumentError

    # Use strict operators when:
    # - Working with pure boolean logic
    # - You want compile-time guarantees about types
    # - Writing guards (only certain operators allowed)
    # - Mathematical/logical expressions
    #
    # Use relaxed operators when:
    # - Providing default values
    # - Safe navigation
    # - Working with mixed types
    # - General conditional logic

    # Example strict usage in guards (defined at module level):
    # def process(data) when is_map(data) and not is_nil(data) do
    #   # Guards require strict operators
    #   transform(data)
    # end
  end

  def test_09_truthiness_in_conditionals do
    # CONCEPT: Conditional Expressions with Truthiness
    #
    # Elixir's if, unless, case, and cond expressions all use truthiness
    # to determine which branch to execute. Understanding this behavior
    # is crucial for writing correct conditional logic.

    # if with truthy values
    result = if "hello", do: "truthy", else: "falsy"
    assert_equal(Enlightenment.__(), result)

    # unless with falsy values
    result = unless nil, do: "executed", else: "not executed"
    assert_equal(Enlightenment.__(), result)

    # case with truthiness
    result =
      case 0 do
        x when x -> "truthy branch"
        _ -> "falsy branch"
      end

    assert_equal(Enlightenment.__(), result)

    # cond uses truthiness for conditions
    result =
      cond do
        [] -> "empty list"
        0 -> "zero"
        false -> "false"
        true -> "catchall"
      end

    assert_equal(Enlightenment.__(), result)

    # Conditional patterns:
    #
    # Safe conditionals:
    # if user, do: greet(user), else: redirect_to_login()
    #
    # Explicit checks are often better:
    # if not is_nil(user), do: greet(user), else: redirect_to_login()
    #
    # Multiple conditions:
    # cond do
    #   is_admin?(user) -> admin_dashboard()
    #   is_member?(user) -> member_dashboard()
    #   true -> public_dashboard()
    # end
  end

  def test_10_comparison_operators do
    # CONCEPT: Equality and Comparison with Booleans
    #
    # Elixir has different equality operators with specific behaviors
    # around truthiness. Understanding these differences helps avoid
    # subtle bugs in boolean logic.

    # Strict equality - checks exact value match
    assert_equal(Enlightenment.__(), nil == false)

    assert_equal(Enlightenment.__(), true == true)

    # Inequality
    assert_equal(Enlightenment.__(), nil != false)

    # Pattern matching equality
    assert_equal(Enlightenment.__(), nil === false)

    # Test truthiness equivalence
    assert_equal(Enlightenment.__(), both_truthy?(nil, false))

    assert_equal(Enlightenment.__(), both_truthy?("hello", 42))

    # Comparison guidelines:
    #
    # Use == for value comparison:
    # user.active == true  # Check explicit boolean
    #
    # Use boolean conversion for truthiness:
    # !!user.name == !!user.email  # Both exist or both don't
    #
    # Be explicit when needed:
    # is_nil(value) rather than value == nil
    # is_boolean(value) to check for true boolean
  end

  def test_11_guards_and_truthiness do
    # CONCEPT: Guards and Boolean Logic
    #
    # Guards in function definitions have special rules about boolean
    # expressions. They require strict boolean operators and specific
    # allowed functions, making them more restrictive but predictable.

    assert_equal(Enlightenment.__(), classify(nil))

    assert_equal(Enlightenment.__(), classify(false))

    assert_equal(Enlightenment.__(), classify(true))

    assert_equal(Enlightenment.__(), classify("hello"))

    # Guard constraints:
    # - Must use 'and', 'or', 'not' (not &&, ||, !)
    # - Only specific BIFs (Built-In Functions) allowed
    # - No custom functions (unless whitelisted)
    # - Must return boolean values
    #
    # Valid guard expressions:
    # when is_atom(x) and not is_nil(x)
    # when value > 0 or value < -10
    # when is_binary(str) and byte_size(str) > 0
    #
    # Invalid in guards:
    # when x && y           # Use 'and' instead
    # when custom_func(x)   # Custom functions not allowed
    # when x in [1, 2, 3]   # 'in' is allowed, this would work
  end

  def test_12_truthiness_patterns_in_real_code do
    # CONCEPT: Real-World Truthiness Patterns
    #
    # Understanding how truthiness works in practice helps you write
    # idiomatic Elixir code. These patterns appear frequently in
    # production applications.

    # Pattern 1: Safe navigation with default
    user = %{name: "Alice", profile: %{bio: "Developer"}}
    bio = (user && user[:profile] && user[:profile][:bio]) || "No bio available"
    assert_equal(Enlightenment.__(), bio)

    # Pattern 2: Configuration with fallbacks
    config = %{database_url: nil, fallback_db: "sqlite://fallback.db"}
    db_url = config[:database_url] || config[:fallback_db] || "sqlite://default.db"
    assert_equal(Enlightenment.__(), db_url)

    # Pattern 3: Conditional processing
    items = [1, 2, 3]

    result =
      if items && length(items) > 0 do
        "Processing #{length(items)} items"
      else
        "No items to process"
      end

    assert_equal(Enlightenment.__(), result)

    # Pattern 4: Boolean coercion for APIs
    api_response = %{success: "yes", active: 1, disabled: 0}
    success = !!api_response[:success]
    active = !!(api_response[:active] && api_response[:active] != 0)
    disabled = !!(api_response[:disabled] && api_response[:disabled] != 0)

    assert_equal(Enlightenment.__(), success)

    assert_equal(Enlightenment.__(), active)

    assert_equal(Enlightenment.__(), disabled)

    # Common anti-patterns to avoid:
    #
    # Don't rely on "empty" being falsy:
    # if list do  # BAD - empty list is truthy
    # if not Enum.empty?(list) do  # GOOD - explicit check
    #
    # Don't assume numeric truthiness:
    # if count do  # BAD - zero is truthy
    # if count > 0 do  # GOOD - explicit comparison
    #
    # Be explicit about nil vs false:
    # setting = config[:feature] || false  # May not be what you want
    # setting = Map.get(config, :feature, false)  # More explicit
  end
end
