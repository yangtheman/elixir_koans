defmodule AboutAtoms do
  @moduledoc """
  Atoms are constants whose name is their value.
  They are often used to tag values or represent state.

  ## Understanding Atoms

  Atoms are one of Elixir's fundamental data types. Think of them as named constants
  or symbols. Unlike strings, atoms are immutable and their value IS their name.

  Key characteristics of atoms:
  - Immutable (cannot be changed)
  - Stored in a global atom table (shared across the entire system)
  - Memory efficient when used repeatedly
  - Fast to compare (pointer comparison, not string comparison)
  - Limited in number (about 1 million total atoms per VM)

  ## Common Uses of Atoms

  - Status indicators: :ok, :error
  - Boolean values: true, false (these are atoms!)
  - Tags in tuples: {:ok, result}, {:error, reason}
  - Keys in keyword lists and maps
  - Module names (though usually written as MyModule, not :Elixir.MyModule)
  - Function names internally

  ## Memory and Performance

  Atoms live forever in memory until the VM shuts down. This makes them perfect
  for constants and identifiers, but dangerous for dynamic content.

  NEVER do: String.to_atom("user_input_" <> user_id)
  DO: Use strings or create a limited set of predefined atoms
  """

  import Enlightenment

  def test_01_atoms_are_symbols do
    # CONCEPT: Atoms as Named Constants
    #
    # An atom is like a named constant. The atom :hello always equals :hello,
    # just like the number 5 always equals 5. The difference is atoms are
    # human-readable identifiers.
    #
    # Example: Instead of using magic numbers like status=1, status=2
    # You can use atoms: status=:active, status=:inactive

    atom = :hello
    assert_equal(Enlightenment.__(), atom)

    # Other atom examples:
    # :world, :ok, :error, :active, :pending, :complete
  end

  def test_02_atoms_are_constants do
    # CONCEPT: Atom Identity and Immutability
    #
    # All atoms with the same name are the exact same object in memory.
    # This is different from strings - two "hello" strings might be
    # different objects, but :hello is always the same :hello everywhere.

    atom1 = :hello
    atom2 = :hello

    assert_equal(atom1, Enlightenment.__())

    # This memory efficiency is why atoms are perfect for tags and constants
  end

  def test_03_atoms_can_be_compared do
    # CONCEPT: Atom Comparison and Boolean Logic
    #
    # Atoms can be compared just like any other values. Since atoms are
    # constants, comparison is very fast (just comparing memory addresses).

    assert_equal(Enlightenment.__(), :hello == :hello)

    assert_equal(Enlightenment.__(), :hello == :world)

    # You can also use other comparison operators:
    # :apple < :banana  # Alphabetical ordering
    # :hello != :world  # Not equal
  end

  def test_04_atoms_have_string_representations do
    # CONCEPT: Converting Between Atoms and Strings
    #
    # While atoms and strings are different types, you can convert between them.
    # This is useful for display purposes or when interfacing with external systems
    # that expect strings.

    atom_as_string = Atom.to_string(:hello)
    assert_equal(Enlightenment.__(), atom_as_string)

    # The conversion creates a new string; the original atom is unchanged
    original_atom = :hello
    _string_version = Atom.to_string(original_atom)
    # original_atom is still :hello, not affected by the conversion
  end

  def test_05_strings_can_be_converted_to_atoms do
    # CONCEPT: String to Atom Conversion (Use with Caution!)
    #
    # You can convert strings to atoms, but be very careful! Each new atom
    # stays in memory forever. Only convert strings to atoms when you have
    # a limited, known set of possible values.

    string = "hello"
    atom = String.to_atom(string)
    assert_equal(Enlightenment.__(), atom)

    # SAFETY: Only use String.to_atom/1 with trusted, limited input
    # For dynamic strings, consider using String.to_existing_atom/1 instead
    # which fails if the atom doesn't already exist
  end

  def test_06_atoms_with_spaces_or_special_chars do
    # CONCEPT: Quoted Atoms for Special Characters
    #
    # Normal atoms follow identifier rules (letters, numbers, underscores).
    # For atoms with spaces, special characters, or starting with uppercase,
    # use quotes around them.

    spaced_atom = :"hello world"
    assert_equal(Enlightenment.__(), spaced_atom)

    # Other examples:
    # :"Hello"     # Uppercase
    # :"hello-world" # Hyphens
    # :"123abc"    # Starting with number
    # :"@special"  # Special characters
  end

  def test_07_atoms_are_used_for_booleans do
    # CONCEPT: Booleans as Special Atoms
    #
    # In Elixir, true and false are not primitive types - they're atoms!
    # This is different from many languages where booleans are separate types.
    # nil is also an atom.

    assert_equal(Enlightenment.__(), true == true)

    assert_equal(Enlightenment.__(), false == false)

    # You can verify this:
    # is_atom(true)   # Returns true
    # is_atom(false)  # Returns true
    # true == :true   # Returns false! (:true is different from true)
  end

  def test_08_nil_is_also_an_atom do
    # CONCEPT: nil as the Absence Atom
    #
    # nil represents the absence of a value, like null in other languages.
    # But in Elixir, nil is actually the atom :nil. This consistency makes
    # the language simpler and more predictable.

    assert_equal(Enlightenment.__(), nil == nil)

    # Useful nil checks:
    # is_nil(nil)        # Returns true
    # is_nil("hello")    # Returns false
    # is_atom(nil)       # Returns true
    # nil == :nil        # Returns true!
  end

  def test_09_atoms_are_used_in_tuples_for_tagging do
    # CONCEPT: Tagged Tuples - The Elixir Way of Result Handling
    #
    # One of the most common uses of atoms is in tagged tuples. Instead of
    # throwing exceptions for errors, Elixir functions often return tuples
    # with atoms indicating success/failure.

    result = {:ok, "success"}
    {status, message} = result

    assert_equal(Enlightenment.__(), status)

    assert_equal(Enlightenment.__(), message)

    # Common patterns:
    # {:ok, value}           # Success with result
    # {:error, reason}       # Error with explanation
    # {:ok, value, metadata} # Success with extra info
    #
    # This makes error handling explicit and prevents silent failures
  end

  def test_10_atoms_are_garbage_collected do
    # CONCEPT: Atom Memory Management - The Forever Problem
    #
    # Unlike most data types, atoms are NEVER garbage collected. Once created,
    # they live in memory until the VM shuts down. This is a feature (fast access)
    # and a potential problem (memory leaks).

    safe_atom = :permanent_atom
    assert_equal(Enlightenment.__(), safe_atom)

    # SAFE: Using predefined atoms
    # :ok, :error, :pending, :active - these are fine

    # DANGEROUS: Creating atoms from user input
    # user_id = "12345"
    # atom = String.to_atom("user_#{user_id}")  # DON'T DO THIS!
    #
    # If users can control atom creation, they can exhaust memory by creating
    # millions of unique atoms. Instead, use strings or maps for dynamic data.

    # SAFER: Check if atom exists first
    # String.to_existing_atom("known_atom")  # Fails if atom doesn't exist
  end

  def test_11_common_atoms_in_elixir do
    # CONCEPT: Conventional Atoms in the Elixir Ecosystem
    #
    # The Elixir community has established conventions for common atoms.
    # Learning these helps you read and write idiomatic Elixir code.

    # Success indicator
    assert_equal(Enlightenment.__(), :ok)

    # Error indicator
    assert_equal(Enlightenment.__(), :error)

    # Undefined/not set value
    assert_equal(Enlightenment.__(), :undefined)

    # Mathematical infinity
    assert_equal(Enlightenment.__(), :infinity)

    # Other common atoms you'll see:
    # :noreply, :stop, :continue  # GenServer states
    # :get, :post, :put, :delete  # HTTP methods
    # :tcp, :udp                  # Network protocols
    # :public, :private           # Access levels
  end

  def test_12_atoms_in_pattern_matching do
    # CONCEPT: Atoms in Pattern Matching and Control Flow
    #
    # Atoms are perfect for pattern matching because they're constants.
    # This makes them ideal for dispatching on different cases or states.

    response = {:error, "File not found"}

    result =
      case response do
        {:ok, data} -> "Success: #{data}"
        {:error, reason} -> "Failed: #{reason}"
        _ -> "Unknown response"
      end

    assert_equal(Enlightenment.__(), result)

    # Pattern matching with atoms is very common in:
    # - Function heads: def handle({:ok, data}), do: ...
    # - Case statements: case result do {:ok, _} -> ...
    # - With statements: with {:ok, user} <- get_user() ...
  end

  def test_13_atom_ordering do
    # CONCEPT: Atom Ordering and Sorting
    #
    # Atoms can be ordered alphabetically by their names. This is useful
    # when you need to sort data that includes atoms or create ordered
    # collections with atom keys.

    atoms = [:zebra, :apple, :banana]
    sorted = Enum.sort(atoms)

    assert_equal(Enlightenment.__(), sorted)

    # Atom ordering follows these rules:
    # 1. Alphabetical by atom name
    # 2. Case sensitive (uppercase comes before lowercase)
    # 3. Numbers and symbols sort before letters
    # 4. Special atoms like true, false, nil have specific positions
  end
end
