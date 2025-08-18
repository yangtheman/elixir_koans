defmodule AboutStrings do
  @moduledoc """
  Strings in Elixir are UTF-8 encoded binaries.
  They are written with double quotes.

  ## Understanding Strings in Elixir

  Strings in Elixir are fundamentally different from many other languages. They are:
  - UTF-8 encoded binaries (not arrays of characters)
  - Immutable (cannot be changed in place)
  - Written with double quotes: "hello"
  - Different from character lists (written with single quotes or ~c sigil)

  ## UTF-8 and Unicode Support

  Elixir's strings support the full Unicode character set, making them suitable
  for international applications. This means strings can contain emoji, accented
  characters, and text from any language.

  ## String vs Character List

  - Strings: "hello" (UTF-8 binary, efficient for most uses)
  - Character lists: ~c"hello" or 'hello' (list of integers, Erlang compatibility)

  ## Performance Characteristics

  - String concatenation (<>) is efficient but creates new strings
  - String slicing creates new strings (no shared references)
  - For many concatenations, consider using IO lists or string interpolation
  - String functions are optimized for UTF-8 processing

  ## Common Patterns

  - Use string interpolation instead of concatenation when possible
  - Pattern match on string prefixes: "prefix" <> rest = "prefix and more"
  - Use String module functions for manipulation
  - Be aware of grapheme vs byte differences in Unicode
  """

  import Enlightenment

  def test_01_double_quoted_strings_are_strings do
    # CONCEPT: String Literals and Basic Syntax
    #
    # In Elixir, strings are written with double quotes. This creates a UTF-8
    # encoded binary that can contain any Unicode characters. Strings are
    # immutable - once created, they cannot be changed.

    string = "Hello, World!"
    assert_equal(Enlightenment.__(), string)

    # Examples of valid string literals:
    # "Simple text"
    # "Text with 'single quotes' inside"
    # "Unicode: 你好, مرحبا, 🌍"
    # ""  # Empty string
    # "Numbers and symbols: 123 !@#"
  end

  def test_02_char_lists_vs_strings do
    # CONCEPT: Character Lists vs Strings - A Critical Distinction
    #
    # This is a common source of confusion! Elixir has TWO ways to represent text:
    # 1. Strings: "hello" (UTF-8 binary, modern Elixir way)
    # 2. Character lists: ~c"hello" or 'hello' (list of integers, legacy Erlang way)
    #
    # They look similar but are completely different data types!

    # This is [72, 101, 108, 108, 111]
    char_list = ~c"Hello"
    # This is a UTF-8 binary
    string = "Hello"

    # They are NOT equal!
    assert_equal(Enlightenment.__(), char_list == string)

    # When to use which:
    # - Strings: 99% of the time (modern Elixir)
    # - Char lists: When interfacing with old Erlang libraries
    #
    # You can convert between them:
    # to_string(~c"Hello") -> "Hello"
    # to_charlist("Hello") -> ~c"Hello"
  end

  def test_03_string_concatenation do
    # CONCEPT: String Concatenation with the <> Operator
    #
    # Strings are immutable in Elixir, so concatenation creates new strings.
    # The <> operator is specifically for string concatenation and only works
    # with binaries (strings).

    hello = "Hello"
    world = "World"

    greeting = hello <> ", " <> world <> "!"
    assert_equal(Enlightenment.__(), greeting)

    # Important: <> only works with strings
    # "Hello" <> "World"  ✓ Works
    # "Hello" <> 123      ✗ Error! Must convert: "Hello" <> to_string(123)
    #
    # For many concatenations, string interpolation is more efficient
  end

  def test_04_string_interpolation do
    # CONCEPT: String Interpolation - The Elixir Way
    #
    # String interpolation is generally preferred over concatenation in Elixir.
    # It's more readable and often more efficient. Any expression can go
    # inside #{}, and it will be converted to a string automatically.

    name = "Elixir"
    message = "Hello, #{name}!"
    assert_equal(Enlightenment.__(), message)

    # Advantages of interpolation:
    # 1. More readable than: "Hello, " <> name <> "!"
    # 2. Automatic type conversion: "Count: #{123}" works
    # 3. Can contain any expression: "Result: #{1 + 2}"
    # 4. More efficient for multiple insertions
  end

  def test_05_string_interpolation_with_expressions do
    # CONCEPT: Complex Expressions in String Interpolation
    #
    # String interpolation can contain any valid Elixir expression, not just
    # variables. This makes it very powerful for creating dynamic strings
    # with computed values.

    x = 3
    y = 4

    result = "The sum of #{x} and #{y} is #{x + y}"
    assert_equal(Enlightenment.__(), result)

    # Examples of expressions in interpolation:
    # "Time: #{DateTime.utc_now()}"
    # "Length: #{length([1, 2, 3])}"
    # "Uppercase: #{String.upcase("hello")}"
    # "Conditional: #{if true, do: "yes", else: "no"}"
  end

  def test_06_escape_sequences do
    # CONCEPT: Escape Sequences for Special Characters
    #
    # Sometimes you need to include special characters in strings that would
    # otherwise be interpreted by the language syntax. Escape sequences let
    # you include these characters literally.

    assert_equal(Enlightenment.__(), "\n")

    assert_equal(Enlightenment.__(), "\t")

    assert_equal(Enlightenment.__(), "\"")

    assert_equal(Enlightenment.__(), "\\")

    # Other useful escape sequences:
    # \r    - carriage return
    # \0    - null character
    # \x41  - hexadecimal character code (A)
    # \u0041 - Unicode code point (A)
  end

  def test_07_multiline_strings do
    # CONCEPT: Multiline String Literals
    #
    # For longer text content, Elixir provides heredoc syntax using triple quotes.
    # This preserves formatting and makes long strings more readable in code.
    # Note: heredocs automatically add a trailing newline.

    multiline = """
    This is a
    multiline string
    """

    assert_equal(Enlightenment.__(), String.ends_with?(multiline, "\n"))

    # Heredoc features:
    # - Preserves indentation and line breaks
    # - Supports string interpolation: "Hello #{name}\nGoodbye"
    # - Strips leading whitespace to match the closing """
    # - Commonly used for documentation and templates
  end

  def test_08_string_length do
    # CONCEPT: Unicode-Aware String Length
    #
    # String.length/1 counts graphemes (user-perceived characters), not bytes.
    # This is crucial for Unicode support - a character like "é" might be 1
    # grapheme but 2 bytes in UTF-8 encoding.

    string = "Hello"
    # é is an accented character
    unicode_string = "Héllo"

    assert_equal(Enlightenment.__(), String.length(string))

    assert_equal(Enlightenment.__(), String.length(unicode_string))

    # Why graphemes matter:
    # - "👨‍👩‍👧‍👦" (family emoji) is 1 grapheme but many Unicode code points
    # - "é" could be 1 code point (é) or 2 code points (e + ´)
    # - String.length/1 gives user-perceived length for proper display
  end

  def test_09_string_byte_size do
    # CONCEPT: Byte Size vs Character Count
    #
    # While String.length/1 counts graphemes, byte_size/1 counts the actual
    # bytes used in UTF-8 encoding. This distinction is important for
    # memory usage, network transmission, and low-level operations.

    string = "Hello"
    # é takes 2 bytes in UTF-8
    unicode_string = "Héllo"

    assert_equal(Enlightenment.__(), byte_size(string))

    assert_equal(Enlightenment.__(), byte_size(unicode_string))

    # When byte_size != String.length:
    # - Non-ASCII characters (accented, emoji, non-Latin scripts)
    # - Combined characters (base + modifying characters)
    # - Most internet protocols and file formats work with bytes, not characters
  end

  def test_10_string_slicing do
    # CONCEPT: Extracting Parts of Strings
    #
    # String.slice/3 extracts a substring using start position and length.
    # It works with grapheme positions, making it Unicode-safe. Negative
    # indices count from the end of the string.

    string = "Hello, World!"

    assert_equal(Enlightenment.__(), String.slice(string, 0, 5))

    assert_equal(Enlightenment.__(), String.slice(string, 7, 5))

    assert_equal(Enlightenment.__(), String.slice(string, -6, 6))

    # String slicing is useful for:
    # - Extracting parts of formatted data
    # - Truncating text for display
    # - Parsing fixed-width data formats
    # - Creating string abbreviations
  end

  def test_11_string_case_conversion do
    # CONCEPT: Case Conversion and Text Normalization
    #
    # Case conversion is common in text processing, but with Unicode it's
    # more complex than just ASCII A-Z. Elixir handles international
    # characters correctly according to Unicode standards.

    string = "Hello, World!"

    assert_equal(Enlightenment.__(), String.upcase(string))

    assert_equal(Enlightenment.__(), String.downcase(string))

    assert_equal(Enlightenment.__(), String.capitalize(string))

    # Unicode considerations:
    # String.upcase("straße")  # "STRASSE" (ß -> SS in German)
    # String.downcase("İstanbul") # "i̇stanbul" (Turkish dotted I)
    # Case conversion respects language-specific rules
  end

  def test_12_string_trimming do
    # CONCEPT: Removing Whitespace
    #
    # Trimming whitespace is essential for processing user input, parsing
    # data files, and cleaning up text. Elixir's trim functions handle
    # all Unicode whitespace characters, not just spaces and tabs.

    string = "  Hello, World!  "

    assert_equal(Enlightenment.__(), String.trim(string))

    assert_equal(Enlightenment.__(), String.trim_leading(string))

    assert_equal(Enlightenment.__(), String.trim_trailing(string))

    # Unicode whitespace includes:
    # - Regular spaces, tabs, newlines
    # - Non-breaking spaces
    # - Various Unicode space characters
    # - Line separators and paragraph separators
  end

  def test_13_string_splitting do
    # CONCEPT: Breaking Strings into Parts
    #
    # String splitting is fundamental for parsing data, processing CSV files,
    # analyzing text, and breaking down structured input. The split function
    # can use strings or regular expressions as separators.

    csv = "apple,banana,cherry"
    assert_equal(Enlightenment.__(), String.split(csv, ","))

    # Useful splitting patterns:
    # String.split("a b c", " ")           # Split on spaces -> ["a", "b", "c"]
    # String.split("line1\nline2", "\n")   # Split lines
    # String.split("a::b::c", "::")        # Multi-character separator
    # String.split(text, ~r/\s+/)          # Split on any whitespace (regex)
    # String.split(csv, ",", parts: 2)     # Limit number of parts
  end

  def test_14_string_joining do
    # CONCEPT: Combining Collections into Strings
    #
    # The opposite of splitting - joining a collection of strings into one
    # string with a separator. This is essential for creating output,
    # building file paths, and formatting lists for display.

    words = ["Hello", "World"]

    assert_equal(Enlightenment.__(), Enum.join(words, " "))

    assert_equal(Enlightenment.__(), Enum.join(words, ", "))

    # Common joining patterns:
    # Enum.join(["a", "b", "c"], "")      # "abc" (no separator)
    # Enum.join([1, 2, 3], "-")           # "1-2-3" (auto-converts to strings)
    # Path.join(["home", "user", "file"]) # OS-appropriate path joining
    #
    # Note: Enum.join can convert non-strings to strings automatically
  end

  def test_15_string_replacement do
    # CONCEPT: Find and Replace Operations
    #
    # String replacement is crucial for data cleaning, template processing,
    # and text transformation. Elixir provides both simple string replacement
    # and powerful regular expression replacement.

    string = "Hello, World!"

    assert_equal(Enlightenment.__(), String.replace(string, "World", "Elixir"))

    # String.replace replaces ALL occurrences by default
    assert_equal(Enlightenment.__(), String.replace(string, "l", "L"))

    # Advanced replacement options:
    # String.replace(str, "old", "new", global: false)  # Replace only first
    # String.replace(str, ~r/\d+/, "X")                 # Regex replacement
    # String.replace(str, "a", &String.upcase/1)        # Function replacement
  end

  def test_16_string_pattern_matching do
    # CONCEPT: Pattern Matching on String Structure
    #
    # One of Elixir's most powerful features is pattern matching strings.
    # You can match prefixes, suffixes, and extract parts of strings
    # directly in function heads or case statements.

    "Hello, " <> rest = "Hello, World!"
    assert_equal(Enlightenment.__(), rest)

    # Pattern matching is incredibly powerful:
    # "HTTP/" <> version = "HTTP/1.1"     # Extract version
    # "error: " <> message = "error: bad" # Extract error message
    # <<first, rest::binary>> = "Hello"   # Extract first byte and rest
    #
    # This enables elegant parsing without complex string operations
  end

  def test_17_string_contains do
    # CONCEPT: String Search and Testing Operations
    #
    # Testing whether strings contain substrings, start with prefixes, or
    # end with suffixes is common in validation, parsing, and filtering
    # operations.

    string = "Hello, World!"

    assert_equal(Enlightenment.__(), String.contains?(string, "World"))

    # String searching is case-sensitive by default
    assert_equal(Enlightenment.__(), String.contains?(string, "world"))

    assert_equal(Enlightenment.__(), String.starts_with?(string, "Hello"))

    assert_equal(Enlightenment.__(), String.ends_with?(string, "!"))

    # For case-insensitive matching:
    # string |> String.downcase() |> String.contains?("world")  # true
    # Or use regular expressions: String.match?(string, ~r/world/i)
  end

  def test_18_strings_are_binaries do
    # CONCEPT: Strings as UTF-8 Encoded Binaries
    #
    # This is a fundamental concept in Elixir: strings are not arrays of
    # characters like in some languages. They are binary data structures
    # containing UTF-8 encoded text. This affects how you process and
    # manipulate strings.

    string = "Hello"
    assert_equal(Enlightenment.__(), is_binary(string))

    # What this means:
    # - Strings are efficient binary data structures
    # - You can use binary pattern matching: <<h, rest::binary>> = "Hello"
    # - String operations work on bytes, but String module functions are UTF-8 aware
    # - You can mix string and binary operations when needed
    #
    # This design makes Elixir strings both memory-efficient and Unicode-capable
  end

  def test_19_string_to_other_types do
    # CONCEPT: Converting Strings to Other Data Types
    #
    # Real applications often need to convert string input (from files, user input,
    # APIs) into other Elixir data types. Understanding safe conversion is crucial
    # for robust applications.

    # String to integer
    assert_equal(Enlightenment.__(), String.to_integer("123"))

    # String to float
    assert_equal(Enlightenment.__(), String.to_float("3.14"))

    # String to atom (be careful!)
    assert_equal(Enlightenment.__(), String.to_existing_atom("hello"))

    # Safe conversions handle invalid input:
    # Integer.parse("123abc") -> {123, "abc"}  # Partial parse
    # Float.parse("3.14x")   -> {3.14, "x"}   # Partial parse
    # String.to_integer("abc") # Raises ArgumentError
    #
    # Always validate input or use safe parsing functions in production!
  end

  def test_20_string_formatting do
    # CONCEPT: Formatted String Output
    #
    # For complex formatting needs beyond string interpolation, Elixir provides
    # powerful formatting functions. These are especially useful for numbers,
    # padding, and creating aligned output.

    # Using :io.format style formatting
    formatted = :io_lib.format("~s has ~p items", ["Cart", 5]) |> to_string()
    assert_equal(Enlightenment.__(), formatted)

    # String padding for alignment
    padded = String.pad_leading("42", 5, "0")
    assert_equal(Enlightenment.__(), padded)

    # Other formatting options:
    # String.pad_trailing("Hi", 5)        # "Hi   "
    # :io_lib.format("~.2f", [3.14159])  # "3.14" (2 decimal places)
    # :io_lib.format("~8s", ["Hi"])      # "      Hi" (right-aligned in 8 chars)
  end
end
