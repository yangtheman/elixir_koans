defmodule AboutStructs do
  @moduledoc """
  Structs provide a way to bring compile-time guarantees to maps.
  They are the foundation for building more complex data types.

  ## Understanding Structs in Elixir

  Structs are named maps with compile-time guarantees about which keys
  they contain. They bridge the gap between the flexibility of maps
  and the structure needed for reliable domain modeling.

  ## What Are Structs?

  A struct is essentially a map with:
  - **Predefined keys:** Keys are defined at compile time
  - **Default values:** Each key can have a default value
  - **Type identity:** Structs have a distinct type (__struct__ key)
  - **Compile-time checking:** Invalid keys cause compilation errors
  - **Pattern matching benefits:** More precise pattern matching

  ## Structs vs Maps vs Records

  **Structs:**
  - Fixed keys at compile time
  - Default values supported
  - Type checking and validation
  - Perfect for domain modeling
  - Pattern matching optimized

  **Maps:**
  - Dynamic keys at runtime
  - Flexible structure
  - No compile-time guarantees
  - Good for configuration and data processing
  - More memory efficient for large datasets

  **Records (deprecated):**
  - Tuple-based (legacy from Erlang)
  - Compile-time only
  - Limited functionality
  - Replaced by structs in modern Elixir

  ## Design Philosophy

  Structs embody Elixir's philosophy of "fail fast" and explicit contracts.
  They make data structures self-documenting and catch errors early in
  the development cycle rather than at runtime.

  ## Domain Modeling Benefits

  **Explicit contracts:** Struct definitions serve as documentation
  **Type safety:** Prevent typos in field names
  **Default values:** Sensible defaults reduce boilerplate
  **Evolution friendly:** Easy to add new fields with defaults
  **Tool support:** Better IDE completion and analysis

  ## Performance Characteristics

  Structs have the same performance as maps for:
  - Field access: O(log n) for large structs, O(1) for small ones
  - Updates: O(log n) with structural sharing
  - Pattern matching: Optimized by compiler
  - Memory usage: Similar to maps plus __struct__ key

  ## Common Use Cases

  **Domain entities:** User, Order, Product, Account
  **Configuration:** Application settings, connection parameters
  **API responses:** Structured data from external services
  **Internal state:** GenServer state, Agent state
  **Error types:** Custom exception types
  **Protocol implementations:** Implementing protocols for custom types

  ## Best Practices for Struct Design

  **Single responsibility:** Each struct should represent one concept
  **Meaningful names:** Use descriptive field names
  **Sensible defaults:** Provide reasonable default values
  **Required fields:** Use @enforce_keys for mandatory fields
  **Documentation:** Document the purpose and fields
  **Validation:** Consider validation functions
  **Immutability:** Design for immutable updates
  """

  import Enlightenment

  # Define a simple struct
  defmodule Person do
    defstruct name: nil, age: 0, email: nil
  end

  def test_01_creating_structs do
    # CONCEPT: Struct Creation and Field Access
    #
    # Structs provide a way to create typed maps with predefined fields.
    # They offer compile-time guarantees about field names while maintaining
    # the flexibility and performance of maps.

    # Create struct with all fields
    alice = %Person{name: "Alice", age: 30, email: "alice@example.com"}

    assert_equal(Enlightenment.__(), alice.name)

    assert_equal(Enlightenment.__(), alice.age)

    # Struct creation patterns:
    #
    # Full specification:
    # user = %User{name: "John", age: 25, email: "john@example.com"}
    #
    # Partial specification (uses defaults):
    # user = %User{name: "Jane"}  # age and email get default values
    #
    # From variables:
    # name = "Bob"
    # age = 35
    # user = %User{name: name, age: age}
    #
    # Field access methods:
    # user.name                    # Direct field access
    # Map.get(user, :name)         # Using Map module
    # user[:name]                  # Bracket notation (works but not idiomatic)
    #
    # Compile-time benefits:
    # %User{invalid_field: "value"}  # Compile error!
    # user.nonexistent_field         # Compile error!
    #
    # This prevents typos and catches errors early:
    # %User{naem: "John"}           # Compile error (typo in 'name')
    # user.eamil                    # Compile error (typo in 'email')
    #
    # Dynamic creation (when needed):
    # fields = %{name: "Dynamic", age: 40}
    # user = struct(User, fields)   # Creates %User{name: "Dynamic", age: 40, email: nil}
    #
    # Struct module information:
    # User.__struct__()             # Returns default struct
    # User.__struct__(age: 50)      # Returns struct with overrides
  end

  def test_02_struct_default_values do
    # CONCEPT: Default Values and Struct Initialization
    #
    # Structs can define default values for fields, making it convenient
    # to create instances with only the essential data while ensuring
    # all fields have sensible defaults.

    # Create struct with some fields (others use defaults)
    bob = %Person{name: "Bob"}

    # Default value
    assert_equal(Enlightenment.__(), bob.age)

    # Default value
    assert_equal(Enlightenment.__(), bob.email)

    # Default value strategies:
    #
    # Simple defaults:
    # defstruct name: "", age: 0, active: true
    #
    # Computed defaults (evaluated once at compile time):
    # defstruct created_at: DateTime.utc_now(), id: UUID.generate()
    # # Warning: These are computed once when module compiles!
    #
    # Nil defaults (explicit):
    # defstruct name: nil, email: nil, phone: nil
    #
    # Collection defaults:
    # defstruct tags: [], metadata: %{}, scores: MapSet.new()
    #
    # Best practices for defaults:
    #
    # ✅ Use meaningful defaults:
    # defstruct status: :pending, retries: 0, timeout: 5000
    #
    # ✅ Avoid expensive computations in defaults:
    # # Bad: computed every time module loads
    # defstruct timestamp: :os.system_time()
    #
    # # Good: computed when needed
    # def new(attrs \\ %{}) do
    #   %__MODULE__{timestamp: :os.system_time()}
    #   |> struct(attrs)
    # end
    #
    # ✅ Use nil for optional fields:
    # defstruct required_field: nil, optional_config: nil
    #
    # ✅ Use empty collections for lists/maps:
    # defstruct items: [], settings: %{}
    #
    # ❌ Avoid mutable defaults:
    # # All instances would share the same Agent!
    # defstruct cache: Agent.start_link(fn -> %{} end)
    #
    # Default value inheritance:
    # When you create a struct with some fields, unspecified fields
    # automatically get their default values:
    #
    # %User{name: "Alice"}
    # # Equivalent to:
    # %User{name: "Alice", age: 0, email: nil}
    #
    # This makes struct creation convenient while ensuring all fields
    # are initialized to predictable values.
  end

  def test_03_updating_structs do
    # CONCEPT: Immutable Updates and Struct Modification
    #
    # Like all Elixir data structures, structs are immutable. Updates
    # create new struct instances with modified values, preserving the
    # original struct unchanged.

    original = %Person{name: "Charlie", age: 25}

    # Update with new values
    updated = %{original | age: 26, email: "charlie@example.com"}

    assert_equal(Enlightenment.__(), updated.age)

    # Unchanged
    assert_equal(Enlightenment.__(), updated.name)

    # Struct update patterns:
    #
    # Single field update:
    # updated_user = %{user | age: user.age + 1}
    #
    # Multiple field updates:
    # updated_user = %{user | name: "New Name", email: "new@email.com"}
    #
    # Conditional updates:
    # updated_user = if user.age >= 18 do
    #   %{user | status: :adult}
    # else
    #   %{user | status: :minor}
    # end
    #
    # Chained updates:
    # result = user
    # |> Map.put(:last_login, DateTime.utc_now())
    # |> Map.update(:login_count, 1, &(&1 + 1))
    #
    # Update functions pattern:
    # defmodule User do
    #   defstruct name: nil, age: 0, email: nil, login_count: 0
    #
    #   def update_age(user, new_age) do
    #     %{user | age: new_age}
    #   end
    #
    #   def increment_logins(user) do
    #     %{user | login_count: user.login_count + 1}
    #   end
    #
    #   def set_email(user, email) do
    #     %{user | email: email}
    #   end
    # end
    #
    # Bulk updates with Map.merge/2:
    # updates = %{age: 30, email: "updated@example.com"}
    # updated_user = Map.merge(user, updates)
    # # Note: This works but loses struct type checking
    #
    # Struct-preserving bulk update:
    # updated_user = struct(user, updates)
    # # Preserves struct type and validates field names
    #
    # Nested struct updates:
    # user_with_address = %{user | address: %{user.address | city: "New City"}}
    #
    # Using put_in/get_in for nested updates:
    # updated = put_in(user.address.city, "New City")
    # city = get_in(user, [:address, :city])
    #
    # Performance considerations:
    # - Updates create new structs (immutable)
    # - Original struct is unchanged
    # - Memory is shared between versions (structural sharing)
    # - Multiple small updates are less efficient than single large update
    #
    # Validation during updates:
    # defmodule User do
    #   def set_age(user, age) when age >= 0 and age <= 150 do
    #     %{user | age: age}
    #   end
    #   def set_age(_user, age) do
    #     {:error, "Invalid age: #{age}"}
    #   end
    # end
  end

  def test_04_struct_pattern_matching do
    # CONCEPT: Pattern Matching with Structs
    #
    # Structs excel at pattern matching, allowing you to destructure
    # data and match on specific field values or combinations.
    # This makes function definitions more expressive and type-safe.

    person = %Person{name: "Diana", age: 28, email: "diana@example.com"}

    # Match specific fields
    %Person{name: name, age: age} = person
    assert_equal(Enlightenment.__(), name)

    assert_equal(Enlightenment.__(), age)

    # Match with literals
    # This succeeds
    %Person{name: "Diana"} = person

    # Pattern matching capabilities:
    #
    # Extract specific fields:
    # %User{name: username, email: email} = user
    #
    # Match literal values:
    # %User{status: :active, age: age} = user
    # # Only matches users with status :active
    #
    # Combine literal and variable matching:
    # %User{name: name, status: :premium} = user
    # # Extract name from premium users only
    #
    # Function pattern matching:
    # defmodule UserService do
    #   def greet(%Person{name: name, age: age}) when age >= 18 do
    #     "Hello, adult #{name}!"
    #   end
    #
    #   def greet(%Person{name: name}) do
    #     "Hello, young #{name}!"
    #   end
    #
    #   def process_user(%User{status: :active} = user) do
    #     # Process active user
    #     perform_active_user_logic(user)
    #   end
    #
    #   def process_user(%User{status: :inactive}) do
    #     {:error, "User is inactive"}
    #   end
    # end
    #
    # Case statement pattern matching:
    # case user do
    #   %User{role: :admin, active: true} ->
    #     grant_admin_access()
    #
    #   %User{role: :user, premium: true} ->
    #     grant_premium_access()
    #
    #   %User{role: :user} ->
    #     grant_basic_access()
    #
    #   %User{active: false} ->
    #     deny_access("Account inactive")
    # end
    #
    # With statement pattern matching:
    # with %User{status: :active} <- user,
    #      %User{email: email} when email != nil <- user do
    #   send_notification(email)
    # else
    #   %User{status: status} -> {:error, "User status: #{status}"}
    #   _ -> {:error, "Invalid user"}
    # end
    #
    # Guard clauses with structs:
    # def can_vote?(%Person{age: age}) when age >= 18, do: true
    # def can_vote?(%Person{}), do: false
    #
    # def process_order(%Order{total: total}) when total > 100 do
    #   apply_bulk_discount(order)
    # end
    #
    # Nested pattern matching:
    # def get_user_city(%User{address: %Address{city: city}}) do
    #   city
    # end
    #
    # def get_user_city(%User{address: nil}) do
    #   "No address"
    # end
    #
    # Pin operator for matching existing values:
    # current_status = :pending
    # case order do
    #   %Order{status: ^current_status} -> "Order is pending"
    #   %Order{status: status} -> "Order status: #{status}"
    # end
    #
    # Pattern matching benefits:
    # ✅ Type safety - catches mismatches at compile time
    # ✅ Expressiveness - clear intent in function definitions
    # ✅ Performance - compiler optimizations
    # ✅ Documentation - patterns serve as documentation
  end

  def test_05_struct_vs_map do
    # CONCEPT: Structs vs Maps Comparison
    #
    # Understanding the relationship between structs and maps helps
    # you choose the right data structure and understand when to
    # convert between them or use map functions on structs.

    person_struct = %Person{name: "Eve"}
    person_map = %{name: "Eve", age: 0, email: nil}

    # Structs are not equal to maps even with same data
    assert_equal(Enlightenment.__(), person_struct == person_map)

    # But they are maps under the hood
    assert_equal(Enlightenment.__(), is_map(person_struct))

    # Struct vs Map relationship:
    #
    # Structs ARE maps:
    # - Implemented using Erlang's map data structure
    # - Have all map capabilities
    # - Include special __struct__ key
    # - Support all Map module functions
    #
    # Key differences:
    #
    # Structure:
    # %Person{name: "John"}        # Has __struct__ key
    # %{name: "John"}              # Plain map
    #
    # Type checking:
    # %Person{invalid: "x"}        # Compile error
    # %{invalid: "x"}              # Valid map
    #
    # Pattern matching:
    # %Person{name: n} = struct    # Only matches Person structs
    # %{name: n} = map            # Matches any map with :name key
    #
    # Equality:
    # %Person{name: "A"} == %{name: "A", age: 0, email: nil, __struct__: Person}  # true
    # %Person{name: "A"} == %{name: "A"}                                          # false
    #
    # Conversion between structs and maps:
    #
    # Struct to map:
    # map = Map.from_struct(person_struct)
    # # Removes __struct__ key, keeps data
    #
    # map = Map.delete(person_struct, :__struct__)
    # # Manual removal of struct key
    #
    # Map to struct:
    # struct = struct(Person, map)
    # # Creates Person struct from map data
    #
    # struct = struct!(Person, map)
    # # Like struct/2 but raises on invalid keys
    #
    # Using Map functions on structs:
    #
    # Map.get(person, :name)           # Works fine
    # Map.put(person, :name, "New")    # Returns map, not struct!
    # Map.keys(person)                 # Includes :__struct__ key
    # Map.values(person)               # Includes Person module
    #
    # Preserving struct type:
    # updated = %{person | name: "New Name"}  # Preserves Person type
    # updated = struct(person, name: "New Name")  # Also preserves type
    #
    # When to use which:
    #
    # Use structs when:
    # ✅ Modeling domain entities
    # ✅ Need compile-time guarantees
    # ✅ Want explicit contracts
    # ✅ Building APIs
    # ✅ Implementing protocols
    #
    # Use maps when:
    # ✅ Dynamic or flexible data
    # ✅ JSON processing
    # ✅ Configuration data
    # ✅ Performance critical (slightly faster)
    # ✅ Working with external data
    #
    # Protocol implementations:
    # Structs can implement protocols while maps cannot:
    #
    # defimpl String.Chars, for: Person do
    #   def to_string(%Person{name: name, age: age}) do
    #     "#{name} (#{age} years old)"
    #   end
    # end
    #
    # "#{person}"  # Works for Person struct
    # "#{map}"     # Would need to implement for Map (global)
  end

  # Define struct with required fields
  defmodule Product do
    @enforce_keys [:name, :price]
    defstruct [:name, :price, description: "No description", in_stock: true]
  end

  def test_06_enforced_keys do
    # CONCEPT: Required Fields and Compile-Time Validation
    #
    # @enforce_keys ensures that certain fields must be provided
    # when creating a struct, preventing runtime errors from
    # missing essential data.

    # This works - all required keys provided
    laptop = %Product{name: "Laptop", price: 999.99}
    assert_equal(Enlightenment.__(), laptop.name)

    # This would fail at compile time:
    # %Product{price: 100}  # Missing required :name key

    # Enforced keys fundamentals:
    #
    # Declaration syntax:
    # @enforce_keys [:field1, :field2]
    # defstruct [:field1, :field2, optional_field: "default"]
    #
    # Multiple required fields:
    # @enforce_keys [:name, :email, :age]
    # defstruct name: nil, email: nil, age: nil, active: true
    #
    # Compile-time checking:
    # %User{name: "John"}              # Compile error: missing email, age
    # %User{name: "John", email: "...", age: 25}  # OK
    #
    # Benefits of enforced keys:
    #
    # ✅ Prevent nil pointer-like errors
    # ✅ Self-documenting required fields
    # ✅ Catch errors at compile time
    # ✅ Make APIs more explicit
    # ✅ Force consideration of essential data
    #
    # Design patterns with enforced keys:
    #
    # Essential business data:
    # defmodule Order do
    #   @enforce_keys [:customer_id, :total, :currency]
    #   defstruct [
    #     :customer_id,
    #     :total,
    #     :currency,
    #     status: :pending,
    #     created_at: nil,
    #     items: []
    #   ]
    # end
    #
    # Configuration structs:
    # defmodule DatabaseConfig do
    #   @enforce_keys [:host, :database]
    #   defstruct [
    #     :host,
    #     :database,
    #     port: 5432,
    #     username: "postgres",
    #     password: nil,
    #     ssl: false
    #   ]
    # end
    #
    # API request structs:
    # defmodule APIRequest do
    #   @enforce_keys [:method, :url]
    #   defstruct [
    #     :method,
    #     :url,
    #     headers: [],
    #     body: nil,
    #     timeout: 5000
    #   ]
    # end
    #
    # Constructor functions with enforced keys:
    # defmodule User do
    #   @enforce_keys [:name, :email]
    #   defstruct [:name, :email, age: nil, active: true]
    #
    #   def new(name, email, opts \\ []) do
    #     struct(__MODULE__, [name: name, email: email] ++ opts)
    #   end
    # end
    #
    # Usage:
    # user = User.new("Alice", "alice@example.com", age: 30)
    #
    # Validation with enforced keys:
    # defmodule Product do
    #   @enforce_keys [:name, :price]
    #   defstruct [:name, :price, description: "", category: nil]
    #
    #   def new(attrs) do
    #     with {:ok, name} <- validate_name(attrs[:name]),
    #          {:ok, price} <- validate_price(attrs[:price]) do
    #       {:ok, struct(__MODULE__, attrs)}
    #     end
    #   end
    #
    #   defp validate_name(name) when is_binary(name) and name != "", do: {:ok, name}
    #   defp validate_name(_), do: {:error, "Invalid name"}
    #
    #   defp validate_price(price) when is_number(price) and price > 0, do: {:ok, price}
    #   defp validate_price(_), do: {:error, "Invalid price"}
    # end
    #
    # Best practices:
    # ✅ Enforce keys for business-critical fields
    # ✅ Provide constructor functions for complex validation
    # ✅ Use meaningful field names
    # ✅ Document why fields are required
    # ❌ Don't enforce keys for optional configuration
    # ❌ Avoid too many required fields (makes struct hard to use)
  end

  def test_07_struct_introspection do
    # CONCEPT: Struct Introspection and Type Information
    #
    # Structs carry type information that can be inspected at runtime,
    # enabling dynamic behavior, protocol dispatch, and debugging
    # capabilities.

    person = %Person{name: "Frank"}

    # Get the struct type
    assert_equal(Enlightenment.__(), person.__struct__)

    # Check if something is a specific struct
    assert_equal(Enlightenment.__(), person.__struct__ == Person)

    # Struct introspection techniques:
    #
    # Type checking:
    # person.__struct__                # Returns Person module
    # person.__struct__ == Person      # true
    # is_struct(person)                # true
    # is_struct(person, Person)        # true
    # is_struct(person, User)          # false
    #
    # Dynamic struct operations:
    # struct_module = person.__struct__
    # default_struct = struct_module.__struct__()
    # new_instance = struct(struct_module, name: "Dynamic")
    #
    # Reflection and debugging:
    # defmodule StructInspector do
    #   def inspect_struct(struct) when is_struct(struct) do
    #     module = struct.__struct__
    #     fields = Map.delete(struct, :__struct__)
    #
    #     %{
    #       type: module,
    #       fields: fields,
    #       field_count: map_size(fields),
    #       field_names: Map.keys(fields)
    #     }
    #   end
    #
    #   def inspect_struct(_), do: {:error, "Not a struct"}
    # end
    #
    # Protocol dispatch based on struct type:
    # defprotocol Serializable do
    #   def serialize(data)
    # end
    #
    # defimpl Serializable, for: Person do
    #   def serialize(%Person{name: name, age: age}) do
    #     %{type: "person", name: name, age: age}
    #   end
    # end
    #
    # defimpl Serializable, for: Product do
    #   def serialize(%Product{name: name, price: price}) do
    #     %{type: "product", name: name, price: price}
    #   end
    # end
    #
    # Generic handling:
    # def process_entity(entity) when is_struct(entity) do
    #   case entity.__struct__ do
    #     Person -> handle_person(entity)
    #     Product -> handle_product(entity)
    #     Order -> handle_order(entity)
    #     _ -> {:error, "Unknown entity type"}
    #   end
    # end
    #
    # Struct validation:
    # def validate_struct(struct, expected_module) do
    #   if is_struct(struct, expected_module) do
    #     {:ok, struct}
    #   else
    #     {:error, "Expected #{expected_module}, got #{struct.__struct__}"}
    #   end
    # end
    #
    # Dynamic struct creation:
    # defmodule StructFactory do
    #   def create(module, attrs) when is_atom(module) do
    #     if Code.ensure_loaded?(module) and function_exported?(module, :__struct__, 0) do
    #       struct(module, attrs)
    #     else
    #       {:error, "Invalid struct module"}
    #     end
    #   end
    # end
    #
    # Polymorphic behavior:
    # defmodule EntityProcessor do
    #   def process(entities) when is_list(entities) do
    #     Enum.map(entities, fn entity ->
    #       case entity.__struct__ do
    #         Person -> "Processed person: #{entity.name}"
    #         Product -> "Processed product: #{entity.name}"
    #         _ -> "Unknown entity type"
    #       end
    #     end)
    #   end
    # end
    #
    # Struct equality across different types:
    # %Person{name: "John"} == %User{name: "John"}  # false (different types)
    #
    # Compile-time vs runtime type checking:
    # # Compile time:
    # %Person{invalid_field: "value"}  # Compile error
    #
    # # Runtime:
    # if is_struct(data, Person) do
    #   process_person(data)
    # end
  end

  # Struct with custom functions
  defmodule BankAccount do
    defstruct balance: 0.0, currency: "USD", account_number: nil

    def new(account_number, currency \\ "USD") do
      %__MODULE__{account_number: account_number, currency: currency}
    end

    def deposit(%__MODULE__{balance: balance} = account, amount) when amount > 0 do
      %{account | balance: balance + amount}
    end

    def withdraw(%__MODULE__{balance: balance} = account, amount)
        when amount > 0 and balance >= amount do
      %{account | balance: balance - amount}
    end

    def withdraw(%__MODULE__{}, _amount) do
      {:error, "Insufficient funds"}
    end
  end

  def test_08_struct_with_functions do
    # CONCEPT: Struct Modules with Behavior Functions
    #
    # Structs are often defined alongside functions that operate on them,
    # creating self-contained modules that encapsulate both data structure
    # and behavior, similar to classes in OOP languages.

    # Create account
    account = BankAccount.new("12345", "EUR")
    assert_equal(Enlightenment.__(), account.currency)

    assert_equal(Enlightenment.__(), account.balance)

    # Deposit money
    account_with_money = BankAccount.deposit(account, 100.0)
    assert_equal(Enlightenment.__(), account_with_money.balance)

    # Successful withdrawal
    after_withdrawal = BankAccount.withdraw(account_with_money, 30.0)
    assert_equal(Enlightenment.__(), after_withdrawal.balance)

    # Failed withdrawal
    failed_withdrawal = BankAccount.withdraw(account, 500.0)
    assert_equal(Enlightenment.__(), failed_withdrawal)

    # Struct module design patterns:
    #
    # Constructor pattern:
    # def new(required_params, optional_params \\ []) do
    #   struct(__MODULE__, [required_params | optional_params])
    # end
    #
    # Builder pattern:
    # defmodule User do
    #   defstruct name: nil, email: nil, age: nil, preferences: %{}
    #
    #   def new(name, email) do
    #     %__MODULE__{name: name, email: email}
    #   end
    #
    #   def with_age(user, age) do
    #     %{user | age: age}
    #   end
    #
    #   def with_preference(user, key, value) do
    #     preferences = Map.put(user.preferences, key, value)
    #     %{user | preferences: preferences}
    #   end
    # end
    #
    # Usage:
    # user = User.new("Alice", "alice@example.com")
    #        |> User.with_age(30)
    #        |> User.with_preference(:theme, "dark")
    #
    # State machine pattern:
    # defmodule Order do
    #   defstruct [:id, :items, :total, status: :pending]
    #
    #   def confirm(%__MODULE__{status: :pending} = order) do
    #     %{order | status: :confirmed}
    #   end
    #   def confirm(%__MODULE__{}), do: {:error, "Cannot confirm order"}
    #
    #   def ship(%__MODULE__{status: :confirmed} = order) do
    #     %{order | status: :shipped}
    #   end
    #   def ship(%__MODULE__{}), do: {:error, "Cannot ship order"}
    #
    #   def complete(%__MODULE__{status: :shipped} = order) do
    #     %{order | status: :completed}
    #   end
    #   def complete(%__MODULE__{}), do: {:error, "Cannot complete order"}
    # end
    #
    # Validation pattern:
    # defmodule Email do
    #   defstruct [:address, :verified]
    #
    #   def new(address) do
    #     with {:ok, normalized} <- normalize(address),
    #          {:ok, validated} <- validate(normalized) do
    #       {:ok, %__MODULE__{address: validated, verified: false}}
    #     end
    #   end
    #
    #   def verify(%__MODULE__{} = email, verification_code) do
    #     if valid_code?(verification_code) do
    #       {:ok, %{email | verified: true}}
    #     else
    #       {:error, "Invalid verification code"}
    #     end
    #   end
    #
    #   defp normalize(address), do: # normalization logic
    #   defp validate(address), do: # validation logic
    #   defp valid_code?(code), do: # verification logic
    # end
    #
    # Transformation pipeline:
    # defmodule Document do
    #   defstruct [:content, :metadata, processing_steps: []]
    #
    #   def normalize(%__MODULE__{} = doc) do
    #     %{doc |
    #       content: String.trim(doc.content),
    #       processing_steps: ["normalize" | doc.processing_steps]
    #     }
    #   end
    #
    #   def sanitize(%__MODULE__{} = doc) do
    #     %{doc |
    #       content: sanitize_html(doc.content),
    #       processing_steps: ["sanitize" | doc.processing_steps]
    #     }
    #   end
    #
    #   def process(doc) do
    #     doc
    #     |> normalize()
    #     |> sanitize()
    #     |> validate()
    #   end
    # end
    #
    # Best practices for struct modules:
    # ✅ Group related functions with struct definition
    # ✅ Use pattern matching for type safety
    # ✅ Return {:ok, struct} | {:error, reason} for fallible operations
    # ✅ Implement common operations (new, update, validate)
    # ✅ Use guards for additional safety
    # ✅ Document expected behavior and constraints
  end

  def test_09_struct_update_syntax do
    # CONCEPT: Advanced Update Patterns and Syntax
    #
    # The struct update syntax provides a clean way to create modified
    # copies of structs. Understanding its capabilities and limitations
    # helps you write more maintainable code.

    account = %BankAccount{balance: 100.0, currency: "USD", account_number: "123"}

    # Update multiple fields
    updated = %{account | balance: 200.0, currency: "EUR"}

    assert_equal(Enlightenment.__(), updated.balance)

    assert_equal(Enlightenment.__(), updated.currency)

    # Unchanged
    assert_equal(Enlightenment.__(), updated.account_number)

    # Update syntax variations and patterns:
    #
    # Single field update:
    # updated = %{struct | field: new_value}
    #
    # Multiple field update:
    # updated = %{struct | field1: value1, field2: value2, field3: value3}
    #
    # Computed updates:
    # updated = %{user |
    #   age: user.age + 1,
    #   last_birthday: Date.utc_today(),
    #   login_count: user.login_count + 1
    # }
    #
    # Conditional updates:
    # updated = %{user |
    #   status: if(user.verified, do: :active, else: :pending),
    #   premium: user.subscription_type == :premium
    # }
    #
    # Nested field updates:
    # updated = %{user |
    #   settings: %{user.settings | theme: "dark", notifications: true}
    # }
    #
    # Update with function results:
    # updated = %{order |
    #   total: calculate_total(order.items),
    #   tax: calculate_tax(order.items, order.location),
    #   shipping: calculate_shipping(order.items, order.address)
    # }
    #
    # Pipeline updates:
    # result = original_struct
    # |> update_field_a(value_a)
    # |> update_field_b(value_b)
    # |> validate()
    #
    # Where update functions are defined as:
    # defp update_field_a(struct, value) do
    #   %{struct | field_a: value}
    # end
    #
    # Bulk updates with validation:
    # def update_user(user, changes) do
    #   validated_changes = validate_changes(changes)
    #   case validated_changes do
    #     {:ok, valid_changes} ->
    #       {:ok, struct(user, valid_changes)}
    #     {:error, _} = error ->
    #       error
    #   end
    # end
    #
    # Dynamic field updates:
    # def update_field(struct, field, value) when is_atom(field) do
    #   Map.put(struct, field, value)
    #   # Note: This returns a map, not a struct!
    #   # Better:
    #   struct(struct, [{field, value}])
    # end
    #
    # Safe update with existence check:
    # def safe_update(struct, field, value) do
    #   if Map.has_key?(struct, field) do
    #     {:ok, Map.put(struct, field, value)}
    #   else
    #     {:error, "Field #{field} does not exist"}
    #   end
    # end
    #
    # Update limitations and gotchas:
    #
    # ❌ Cannot add new fields:
    # %{user | new_field: "value"}  # Compile error!
    #
    # ❌ Cannot update with invalid fields:
    # %{user | invalid_field: "value"}  # Compile error!
    #
    # ✅ Can only update existing struct fields:
    # %{user | name: "new name"}  # OK if :name is defined
    #
    # ❌ Watch out for map operations:
    # Map.put(struct, :field, value)     # Returns map, loses struct type!
    # %{struct | field: value}           # Preserves struct type
    #
    # Performance considerations:
    # - Updates create new structs (immutable)
    # - Structural sharing minimizes memory usage
    # - Multiple small updates less efficient than single large update
    # - Consider batching updates when possible
    #
    # Functional update helpers:
    # def increment_field(struct, field) do
    #   current_value = Map.get(struct, field, 0)
    #   Map.put(struct, field, current_value + 1)
    # end
    #
    # def append_to_list_field(struct, field, item) do
    #   current_list = Map.get(struct, field, [])
    #   Map.put(struct, field, [item | current_list])
    # end
  end

  # Nested structs example
  defmodule Address do
    defstruct street: nil, city: nil, country: nil
  end

  defmodule PersonWithAddress do
    defstruct name: nil, address: nil
  end

  def test_10_nested_structs do
    # CONCEPT: Nested Struct Composition and Management
    #
    # Nested structs allow you to compose complex data structures
    # from simpler ones, enabling hierarchical data modeling that
    # mirrors real-world domain relationships.

    person = %PersonWithAddress{
      name: "Grace",
      address: %Address{
        street: "123 Main St",
        city: "New York",
        country: "USA"
      }
    }

    assert_equal(Enlightenment.__(), person.address.city)

    assert_equal(Enlightenment.__(), person.address.country)

    # Nested struct patterns and techniques:
    #
    # Deep nesting composition:
    # defmodule Company do
    #   defstruct name: nil, headquarters: nil, employees: []
    # end
    #
    # defmodule Employee do
    #   defstruct name: nil, position: nil, address: nil, salary: nil
    # end
    #
    # company = %Company{
    #   name: "Tech Corp",
    #   headquarters: %Address{city: "San Francisco", country: "USA"},
    #   employees: [
    #     %Employee{
    #       name: "Alice",
    #       position: "Engineer",
    #       address: %Address{city: "Berkeley", country: "USA"},
    #       salary: 120_000
    #     }
    #   ]
    # }
    #
    # Accessing nested data:
    # city = person.address.city
    # employee_city = company.employees |> List.first() |> Map.get(:address) |> Map.get(:city)
    #
    # Using get_in/2 for safe nested access:
    # city = get_in(person, [:address, :city])
    # employee_address = get_in(company, [:employees, Access.at(0), :address, :city])
    #
    # Updating nested structures:
    #
    # Direct nested update:
    # updated_person = %{person |
    #   address: %{person.address | city: "Boston"}
    # }
    #
    # Using put_in/3:
    # updated_person = put_in(person.address.city, "Boston")
    # updated_person = put_in(person, [:address, :city], "Boston")
    #
    # Using update_in/3:
    # updated_person = update_in(person.address.city, &String.upcase/1)
    # updated_person = update_in(person, [:address, :city], &String.upcase/1)
    #
    # Nested validation pattern:
    # defmodule PersonValidator do
    #   def validate(%PersonWithAddress{} = person) do
    #     with {:ok, name} <- validate_name(person.name),
    #          {:ok, address} <- validate_address(person.address) do
    #       {:ok, %{person | name: name, address: address}}
    #     end
    #   end
    #
    #   defp validate_name(name) when is_binary(name) and name != "", do: {:ok, name}
    #   defp validate_name(_), do: {:error, "Invalid name"}
    #
    #   defp validate_address(%Address{} = address) do
    #     with {:ok, city} <- validate_city(address.city),
    #          {:ok, country} <- validate_country(address.country) do
    #       {:ok, %{address | city: city, country: country}}
    #     end
    #   end
    #   defp validate_address(_), do: {:error, "Invalid address"}
    # end
    #
    # Builder pattern for nested structs:
    # defmodule PersonBuilder do
    #   def new(name) do
    #     %PersonWithAddress{name: name}
    #   end
    #
    #   def with_address(person, street, city, country) do
    #     address = %Address{street: street, city: city, country: country}
    #     %{person | address: address}
    #   end
    #
    #   def with_city(person, city) do
    #     address = %{person.address | city: city}
    #     %{person | address: address}
    #   end
    # end
    #
    # Usage:
    # person = PersonBuilder.new("Grace")
    #          |> PersonBuilder.with_address("123 Main St", "NYC", "USA")
    #          |> PersonBuilder.with_city("Boston")
    #
    # Pattern matching with nested structs:
    # def get_city(%PersonWithAddress{address: %Address{city: city}}) do
    #   city
    # end
    #
    # def get_city(%PersonWithAddress{address: nil}) do
    #   "No address"
    # end
    #
    # case person do
    #   %PersonWithAddress{address: %Address{country: "USA"}} ->
    #     "US resident"
    #   %PersonWithAddress{address: %Address{country: country}} ->
    #     "International resident from #{country}"
    #   %PersonWithAddress{address: nil} ->
    #     "No address on file"
    # end
    #
    # Serialization considerations:
    # defimpl Jason.Encoder, for: PersonWithAddress do
    #   def encode(%PersonWithAddress{name: name, address: address}, opts) do
    #     Jason.Encode.map(%{name: name, address: address}, opts)
    #   end
    # end
    #
    # defimpl Jason.Encoder, for: Address do
    #   def encode(%Address{} = address, opts) do
    #     address
    #     |> Map.from_struct()
    #     |> Jason.Encode.map(opts)
    #   end
    # end
    #
    # Best practices for nested structs:
    # ✅ Keep nesting levels reasonable (2-3 max)
    # ✅ Use meaningful names for nested fields
    # ✅ Provide convenience functions for common operations
    # ✅ Validate nested data appropriately
    # ✅ Consider using protocols for polymorphic behavior
    # ❌ Avoid deep nesting that makes code hard to follow
    # ❌ Don't create circular references between structs
  end

  def test_11_struct_as_map_operations do
    # CONCEPT: Struct and Map Function Interoperability
    #
    # Since structs are built on top of maps, they can use most Map
    # module functions. Understanding this relationship helps you
    # leverage the full power of Elixir's data manipulation tools.

    person = %Person{name: "Henry", age: 40}

    # Use Map functions on structs
    keys = Map.keys(person)
    assert_equal(Enlightenment.__(), :__struct__ in keys)

    assert_equal(Enlightenment.__(), :name in keys)

    # Get values like a map
    name = Map.get(person, :name)
    assert_equal(Enlightenment.__(), name)

    # Map operations on structs:
    #
    # Reading operations (safe for structs):
    # Map.get(struct, :field)              # Get field value
    # Map.get(struct, :field, default)     # Get with default
    # Map.fetch(struct, :field)            # Returns {:ok, value} | :error
    # Map.fetch!(struct, :field)           # Returns value or raises
    # Map.has_key?(struct, :field)         # Check if field exists
    # Map.keys(struct)                     # List all keys (includes :__struct__)
    # Map.values(struct)                   # List all values (includes module)
    #
    # Modification operations (return maps, not structs):
    # Map.put(struct, :field, value)       # Returns map!
    # Map.delete(struct, :field)           # Returns map!
    # Map.merge(struct, other_map)         # Returns map!
    # Map.drop(struct, [:field1, :field2]) # Returns map!
    #
    # Struct-preserving alternatives:
    # %{struct | field: value}             # Preserves struct type
    # struct(struct, field: value)         # Preserves struct type
    #
    # Conversion operations:
    # Map.from_struct(struct)              # Convert to plain map
    # struct(Person, map)                  # Convert map to Person struct
    #
    # Iteration and transformation:
    # Map.to_list(person)                  # Convert to keyword list
    # # [__struct__: Person, name: "Henry", age: 40, email: nil]
    #
    # Enum.map(person, fn {key, value} ->
    #   {key, transform(value)}
    # end)
    # # Works but returns keyword list, not struct
    #
    # for {key, value} <- person, key != :__struct__, into: %{} do
    #   {key, transform(value)}
    # end
    # # Creates new map without struct info
    #
    # Filtering struct fields:
    # defmodule StructUtils do
    #   def filter_fields(struct, predicate) do
    #     struct
    #     |> Map.from_struct()
    #     |> Enum.filter(predicate)
    #     |> Enum.into(%{})
    #   end
    #
    #   def non_nil_fields(struct) do
    #     filter_fields(struct, fn {_key, value} -> value != nil end)
    #   end
    #
    #   def field_names(struct) do
    #     struct
    #     |> Map.keys()
    #     |> List.delete(:__struct__)
    #   end
    # end
    #
    # Safe map operations:
    # defmodule SafeMapOps do
    #   def safe_get(struct, field) when is_struct(struct) do
    #     if Map.has_key?(struct, field) do
    #       {:ok, Map.get(struct, field)}
    #     else
    #       {:error, "Field #{field} not found in #{struct.__struct__}"}
    #     end
    #   end
    #
    #   def safe_update(struct, field, value) when is_struct(struct) do
    #     if Map.has_key?(struct, field) do
    #       {:ok, Map.put(struct, field, value)}
    #     else
    #       {:error, "Cannot update non-existent field #{field}"}
    #     end
    #   end
    # end
    #
    # Common gotchas:
    #
    # ❌ Losing struct type:
    # updated = Map.put(person, :name, "New Name")
    # # updated is now a map, not a Person struct!
    #
    # ✅ Preserving struct type:
    # updated = %{person | name: "New Name"}
    # # updated is still a Person struct
    #
    # ❌ Unexpected keys in Map operations:
    # Map.keys(person)  # [:__struct__, :name, :age, :email]
    # # Don't forget about :__struct__ key!
    #
    # ✅ Filtering out struct key when needed:
    # data_keys = person |> Map.keys() |> List.delete(:__struct__)
    #
    # Working with JSON and external data:
    # # Converting struct for JSON serialization
    # json_ready = Map.from_struct(person)
    # json_string = Jason.encode!(json_ready)
    #
    # # Reconstructing from JSON
    # {:ok, data} = Jason.decode(json_string)
    # person = struct(Person, data)
    #
    # Dynamic field access:
    # field_name = :name
    # value = Map.get(person, field_name)  # Dynamic field access
    #
    # # With pattern matching (when field name is known at compile time)
    # %Person{name: value} = person        # Static field access
    #
    # Performance considerations:
    # - Map operations on structs have same performance as on maps
    # - Struct type checking adds minimal overhead
    # - Pattern matching on structs is optimized by compiler
    # - Large structs benefit from structural sharing like maps
  end
end
