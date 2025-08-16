defmodule AboutNumbers do
  @moduledoc """
  Elixir supports integers and floating point numbers.

  ## Understanding Numbers in Elixir

  Numbers are fundamental to programming, and Elixir provides excellent support
  for both integer and floating-point arithmetic. Unlike some languages, Elixir
  makes the distinction between integer and float operations explicit.

  ## Integer Types
  - Arbitrary precision (can be as large as memory allows)
  - Signed (can be negative or positive)
  - Various bases: binary (0b), octal (0o), hexadecimal (0x)
  - Support underscores for readability: 1_000_000

  ## Floating Point Numbers
  - IEEE 754 double precision (64-bit)
  - Scientific notation support: 1.23e4
  - Always result from / division operator
  - Mixing integers and floats produces floats

  ## Mathematical Operations
  - Basic arithmetic: +, -, *, /
  - Integer division: div/2, rem/2
  - Mathematical functions via :math module
  - Comparison operators work as expected

  ## Type Coercion Rules
  - Operations between same types keep the type
  - Operations between different types promote to float
  - Division (/) always returns float, even with integers
  - Use div/2 for integer division
  """

  import Enlightenment

  def test_01_integer_arithmetic do
    # CONCEPT: Basic Integer Arithmetic
    #
    # Integer arithmetic in Elixir works as you'd expect from mathematics.
    # When both operands are integers, the result is an integer.
    # Elixir integers have arbitrary precision - they can be as large as memory allows.

    assert_equal(Enlightenment.__(), 1 + 1)

    assert_equal(Enlightenment.__(), 10 - 5)

    assert_equal(Enlightenment.__(), 3 * 4)

    assert_equal(Enlightenment.__(), 20 / 5)

    # Key insight: The / operator ALWAYS returns a float, even with integers
    # This is different from some languages where 20/5 might return 4 (integer)
  end

  def test_02_integer_division do
    # CONCEPT: Integer Division with div/2
    #
    # When you want integer division (truncating the decimal part), use div/2.
    # This is useful for algorithms that need to work with whole numbers only.

    assert_equal(Enlightenment.__(), div(10, 3))

    assert_equal(Enlightenment.__(), div(10, 2))

    assert_equal(Enlightenment.__(), div(-10, 3))

    # Important: div/2 truncates toward zero, not toward negative infinity
    # div(-10, 3) = -3, not -4
    # This is different from floor division in some languages
  end

  def test_03_remainder_operation do
    # CONCEPT: Remainder (Modulo) Operation
    #
    # The rem/2 function gives you the remainder after integer division.
    # This is essential for many algorithms like checking even/odd,
    # cycling through arrays, or hash table implementations.

    assert_equal(Enlightenment.__(), rem(10, 3))

    assert_equal(Enlightenment.__(), rem(10, 2))

    assert_equal(Enlightenment.__(), rem(-10, 3))

    # Useful patterns:
    # rem(n, 2) == 0  # Check if n is even
    # rem(n, 2) == 1  # Check if n is odd
    # rem(index, length) # Wrap around in circular arrays
  end

  def test_04_floating_point_arithmetic do
    # CONCEPT: Floating Point Precision and Operations
    #
    # Floating point numbers represent real numbers with decimal precision.
    # They follow IEEE 754 standard, which means they have precision limits
    # and can have small rounding errors.

    assert_equal(Enlightenment.__(), 1.0 + 1.0)

    assert_equal(Enlightenment.__(), 10.0 - 5.5)

    assert_equal(Enlightenment.__(), 3.2 * 4.0)

    assert_equal(Enlightenment.__(), 20.0 / 4.0)

    # Note: Floating point arithmetic can have small precision errors
    # 0.1 + 0.2 might not exactly equal 0.3 due to binary representation
    # For exact decimal arithmetic, consider using the Decimal library
  end

  def test_05_mixing_integers_and_floats do
    # CONCEPT: Type Promotion in Mixed Arithmetic
    #
    # When you mix integers and floats in an operation, Elixir promotes
    # the result to a float. This prevents precision loss and follows
    # mathematical intuition.

    assert_equal(Enlightenment.__(), 1 + 1.0)

    assert_equal(Enlightenment.__(), 10 - 5.5)

    assert_equal(Enlightenment.__(), 3 * 4.0)

    # This automatic promotion prevents unexpected truncation:
    # If 3 * 4.0 returned 12 (integer), you'd lose the decimal precision
    # If 10 - 5.5 returned 4 (integer), you'd lose the .5
  end

  def test_06_division_always_returns_float do
    # CONCEPT: The Division Operator Always Returns Floats
    #
    # This is a key difference from some languages. In Elixir, the / operator
    # is specifically for floating-point division. This makes the behavior
    # predictable - you always get the mathematically correct result.

    assert_equal(Enlightenment.__(), 10 / 5)

    assert_equal(Enlightenment.__(), 9 / 3)

    # Why this design?
    # 1. Prevents accidental truncation: 10/3 gives 3.3333..., not 3
    # 2. Makes division behavior predictable and consistent
    # 3. Separates integer division (div/2) from real division (/)
    #
    # For integer division, explicitly use div/2
    # For real division, use / (gets float result)
  end

  def test_07_large_numbers do
    # CONCEPT: Arbitrary Precision Integers
    #
    # Unlike many languages with fixed-size integers (32-bit, 64-bit),
    # Elixir integers can be as large as available memory. This prevents
    # integer overflow bugs and makes mathematical operations more predictable.

    big_number = 123_456_789_012_345_678_901_234_567_890
    assert_equal(Enlightenment.__(), big_number + 10)

    # This is particularly useful for:
    # - Cryptographic calculations
    # - Financial calculations requiring precision
    # - Mathematical algorithms that generate large numbers
    # - Factorial calculations: 100! is a very large number

    # Performance note: Very large integers do use more memory and CPU
    # but the automatic handling prevents silent overflow errors
  end

  def test_08_number_systems do
    # CONCEPT: Different Number Base Representations
    #
    # Programmers often work with different number systems, especially
    # when dealing with low-level programming, bit operations, or
    # interfacing with hardware or systems that use these representations.

    # Binary (base 2) - each digit is 0 or 1
    assert_equal(Enlightenment.__(), 0b1010)

    # Octal (base 8) - digits 0-7
    assert_equal(Enlightenment.__(), 0o12)

    # Hexadecimal (base 16) - digits 0-9, A-F
    assert_equal(Enlightenment.__(), 0xFF)

    # These are all just different ways to write the same integers
    # 0b1010 == 0o12 == 0xFF == 10  # All represent the same number!
  end

  def test_09_underscores_in_numbers do
    # CONCEPT: Numeric Literals with Underscores for Readability
    #
    # Large numbers can be hard to read. Elixir allows underscores in
    # numeric literals to improve readability. The underscores are ignored
    # by the compiler - they're purely for human readers.

    million = 1_000_000
    assert_equal(Enlightenment.__(), million)

    # Other examples:
    # credit_card = 1234_5678_9012_3456
    # binary_flags = 0b1010_1100_0011_1111
    # hex_color = 0xFF_AA_BB_CC
    # scientific = 6.022_141_29e23  # Avogadro's number

    # The underscores can go anywhere within the number (but not at start/end)
    # This follows conventions from other languages and mathematics
  end

  def test_10_scientific_notation do
    # CONCEPT: Scientific Notation for Very Large or Small Numbers
    #
    # Scientific notation is useful for very large or very small numbers.
    # It's written as: coefficient * 10^exponent, displayed as 1.23e4

    # 1.23 * 10^4
    scientific = 1.23e4
    assert_equal(Enlightenment.__(), scientific)

    # Other examples:
    # 6.022e23   # Avogadro's number (very large)
    # 1.6e-19    # Charge of an electron (very small)
    # 3.0e8      # Speed of light in m/s
    # 9.81e0     # Earth's gravity (same as 9.81)

    # The 'e' can be uppercase (E) or lowercase (e)
    # Negative exponents represent very small numbers: 1e-6 = 0.000001
  end

  def test_11_mathematical_functions do
    # CONCEPT: Built-in Mathematical Functions
    #
    # Elixir provides mathematical functions through the :math module (Erlang)
    # and some built-in functions. These are essential for scientific computing,
    # graphics, game development, and many algorithmic problems.

    assert_equal(Enlightenment.__(), round(:math.sqrt(16)))

    assert_equal(Enlightenment.__(), trunc(:math.pow(2, 3)))

    assert_equal(Enlightenment.__(), abs(-5))

    # Other useful math functions:
    # :math.sin(x), :math.cos(x), :math.tan(x)  # Trigonometry
    # :math.log(x), :math.log10(x)              # Logarithms
    # :math.exp(x)                              # e^x
    # :math.ceil(x), :math.floor(x)             # Rounding
    # min(a, b), max(a, b)                      # Comparison
  end

  def test_12_comparison_operators do
    # CONCEPT: Numeric Comparisons and Ordering
    #
    # Numbers can be compared using standard mathematical operators.
    # These comparisons return boolean values (true/false atoms).
    # Comparisons work between integers and floats as expected.

    assert_equal(Enlightenment.__(), 5 > 3)

    assert_equal(Enlightenment.__(), 2 < 1)

    assert_equal(Enlightenment.__(), 5 >= 5)

    assert_equal(Enlightenment.__(), 3 <= 2)

    assert_equal(Enlightenment.__(), 5 == 5)

    assert_equal(Enlightenment.__(), 5 != 3)

    # These operators work between integers and floats:
    # 5 > 4.9    # true
    # 3.0 == 3   # true (value equality)
  end

  def test_13_strict_equality do
    # CONCEPT: Value Equality vs Type Equality
    #
    # Elixir has two equality operators:
    # == checks value equality (allows type coercion)
    # === checks strict equality (same type AND same value)

    assert_equal(Enlightenment.__(), 5 === 5)

    assert_equal(Enlightenment.__(), 5 === 5.0)

    assert_equal(Enlightenment.__(), 5 == 5.0)

    # When to use which?
    # == for value comparison (most common): "is the number 5?"
    # === for type-safe comparison: "is it exactly the integer 5?"

    # This distinction is important for pattern matching and
    # when you need to distinguish between 5 and 5.0 for some reason
  end

  def test_14_numeric_type_checking do
    # CONCEPT: Checking Number Types
    #
    # Sometimes you need to determine what type of number you're working with.
    # Elixir provides type-checking functions for this purpose.

    assert_equal(Enlightenment.__(), is_integer(42))

    assert_equal(Enlightenment.__(), is_float(42))

    assert_equal(Enlightenment.__(), is_float(42.0))

    assert_equal(Enlightenment.__(), is_number(42))

    assert_equal(Enlightenment.__(), is_number(42.5))

    # These are useful for:
    # - Input validation
    # - Polymorphic functions that handle numbers differently
    # - Debugging type-related issues
  end

  def test_15_number_conversion do
    # CONCEPT: Converting Between Number Types
    #
    # Sometimes you need to explicitly convert between integers and floats.
    # Elixir provides functions for safe conversions.

    # Float to integer (truncates decimal part)
    assert_equal(Enlightenment.__(), trunc(3.7))

    assert_equal(Enlightenment.__(), round(3.7))

    assert_equal(Enlightenment.__(), floor(3.7))

    assert_equal(Enlightenment.__(), ceil(3.2))

    # Integer to float
    assert_equal(Enlightenment.__(), 42 + 0.0)

    # More explicit: 42 / 1 also gives 42.0
    # Or use: :erlang.float(42)
  end
end
