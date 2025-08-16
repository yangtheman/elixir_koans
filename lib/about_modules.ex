defmodule AboutModules do
  @moduledoc """
  Modules are the basic unit of code organization in Elixir.
  They provide namespacing and encapsulation.

  ## Understanding Modules in Elixir

  Modules are the fundamental building blocks of Elixir applications. They serve
  as containers for functions, constants, types, and other modules, providing
  organization, namespacing, and encapsulation for your code.

  ## Core Module Concepts

  **Namespacing:** Modules prevent naming conflicts by creating unique namespaces
  **Encapsulation:** Private functions (defp) hide implementation details
  **Organization:** Group related functionality together
  **Compilation units:** Each module is compiled independently
  **Runtime entities:** Modules exist at runtime and can be introspected

  ## Module Definition and Compilation

  Modules in Elixir are defined at compile time but exist as first-class
  entities at runtime. This dual nature enables powerful metaprogramming
  capabilities while maintaining performance.

  ## Module Structure

  A typical module contains:
  - Module documentation (@moduledoc)
  - Module attributes (@attribute)
  - Function definitions (def/defp)
  - Nested modules (defmodule within defmodule)
  - Imports, aliases, and requires
  - Macros and callbacks

  ## Visibility and Scope

  **Public functions (def):** Callable from outside the module
  **Private functions (defp):** Only callable within the module
  **Module attributes:** Compile-time constants and metadata
  **Nested modules:** Have their own namespace

  ## Module Discovery and Loading

  Elixir uses the module name to locate the corresponding compiled bytecode.
  The module system integrates with the code loading mechanism to enable
  features like hot code swapping and dynamic module loading.

  ## Best Practices for Module Design

  **Single responsibility:** Each module should have one clear purpose
  **Consistent naming:** Follow Elixir conventions (PascalCase)
  **Logical grouping:** Related functions belong together
  **Clear interfaces:** Public API should be well-defined
  **Documentation:** Always document public modules and functions

  ## Module Relationships

  Modules interact through several mechanisms:
  - **alias:** Create shorter names for long module paths
  - **import:** Bring functions into local scope
  - **require:** Make macros available
  - **use:** Execute module's __using__ macro
  """

  import Enlightenment

  def test_01_defining_modules do
    # CONCEPT: Module Definition and Function Organization
    #
    # Modules are the primary way to organize code in Elixir. They create
    # namespaces that prevent naming conflicts and group related functionality.
    # Every function must belong to a module.

    defmodule SimpleModule do
      def hello, do: "Hello from SimpleModule"
    end

    assert_equal(Enlightenment.__(), SimpleModule.hello())

    # Module definition fundamentals:
    #
    # Syntax: defmodule ModuleName do ... end
    # - ModuleName must be an atom (usually PascalCase)
    # - Can contain any valid Elixir code
    # - Compiled to bytecode (.beam files)
    # - Exist as atoms in the runtime system
    #
    # Module naming conventions:
    # MyApp.UserService      # Top-level application module
    # MyApp.Accounts.User    # Nested functional area
    # MyApp.Web.Router       # Web-specific functionality
    #
    # Module compilation process:
    # 1. Parse module definition
    # 2. Expand macros and compile functions
    # 3. Generate bytecode
    # 4. Store in code server
    # 5. Make available for calls
    #
    # Function organization principles:
    # - Group related functions together
    # - Use consistent naming patterns
    # - Order functions logically (public first, private last)
    # - Keep modules focused (single responsibility)
    #
    # Module as namespace:
    # Different modules can have functions with the same name:
    # String.length/1 vs Enum.count/1
    # Both operate on different data types and contexts
  end

  def test_03_module_attributes do
    # CONCEPT: Module Attributes and Compile-Time Constants
    #
    # Module attributes serve as compile-time constants, configuration,
    # and metadata storage. They're computed once during compilation
    # and can be used throughout the module.

    defmodule AttributeExample do
      @greeting "Hello"
      @count 42

      def get_greeting, do: @greeting
      def get_count, do: @count
    end

    assert_equal(Enlightenment.__(), AttributeExample.get_greeting())

    assert_equal(Enlightenment.__(), AttributeExample.get_count())

    # Module attribute characteristics:
    #
    # Compile-time evaluation: Values computed during compilation
    # Immutable: Cannot be changed after definition
    # Scope: Available throughout the module
    # Memory efficient: Stored once in bytecode
    #
    # Common attribute use cases:
    #
    # Configuration constants:
    # @default_timeout 5000
    # @max_retries 3
    # @api_version "v1"
    #
    # Documentation:
    # @moduledoc "This module handles user authentication"
    # @doc "Authenticates a user with email and password"
    #
    # Type specifications:
    # @spec login(String.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
    #
    # Behaviour declarations:
    # @behaviour GenServer
    # @behaviour MyApp.PaymentProcessor
    #
    # Computed attributes:
    # @compile_time DateTime.utc_now()
    # @version Mix.Project.config()[:version]
    #
    # Built-in attributes with special meaning:
    # @moduledoc, @doc, @spec, @type, @callback, @behaviour,
    # @compile, @external_resource, @on_load, @before_compile
    #
    # Accumulating attributes (can be set multiple times):
    # @compile {:inline, small_function: 0}
    # @compile :debug_info
  end

  def test_07_nested_modules do
    # CONCEPT: Module Hierarchy and Namespacing
    #
    # Nested modules create hierarchical namespaces, enabling logical
    # organization of code. They're independent modules that happen
    # to share a naming prefix.

    defmodule Outer do
      defmodule Inner do
        def nested_function, do: "I'm nested"
      end
    end

    assert_equal(Enlightenment.__(), Outer.Inner.nested_function())

    # Nested module concepts:
    #
    # Independence: Nested modules are separate entities
    # - Outer.Inner is a completely different module from Outer
    # - They don't share scope or state
    # - Each compiles to its own bytecode
    #
    # Naming hierarchy:
    # MyApp                    # Root module
    # ├── MyApp.Accounts       # Feature area
    # │   ├── MyApp.Accounts.User      # Domain entity
    # │   └── MyApp.Accounts.Settings  # Related functionality
    # └── MyApp.Web            # Interface layer
    #     ├── MyApp.Web.Router         # Routing
    #     └── MyApp.Web.Controller     # Request handling
    #
    # Benefits of nesting:
    # 1. Logical organization
    # 2. Namespace management
    # 3. Related code proximity
    # 4. Clear dependency hierarchies
    #
    # Common nesting patterns:
    #
    # Context-based (Phoenix style):
    # MyApp.Accounts.User
    # MyApp.Accounts.UserToken
    # MyApp.Accounts.Permission
    #
    # Layer-based:
    # MyApp.Core.User         # Domain logic
    # MyApp.Web.UserController # Web interface
    # MyApp.Repo.UserQueries   # Data access
    #
    # Feature-based:
    # MyApp.Authentication.Service
    # MyApp.Authentication.Token
    # MyApp.Authentication.Policy
    #
    # Access patterns:
    # Full qualification: MyApp.Accounts.User.create/1
    # With alias: User.create/1 (after alias MyApp.Accounts.User)
  end

  def test_module_aliases do
    # CONCEPT: Aliases and Import Management
    #
    # Aliases create short names for long module paths, improving
    # code readability and reducing typing. They're compile-time
    # transformations that don't affect runtime performance.

    defmodule VeryLongModuleName do
      def function, do: "Hello from long name"
    end

    defmodule UsingAlias do
      alias VeryLongModuleName, as: Short

      def call_aliased, do: Short.function()
    end

    assert_equal(Enlightenment.__(), UsingAlias.call_aliased())

    # Alias mechanics and patterns:
    #
    # Basic alias syntax:
    # alias MyApp.Accounts.User          # User becomes shortcut
    # alias MyApp.Accounts.User, as: U   # Custom name
    #
    # Multiple aliases:
    # alias MyApp.Accounts.{User, Permission, Role}
    # # Creates: User, Permission, Role
    #
    # Scoped aliases (only within current module):
    # defmodule MyModule do
    #   alias SomeVeryLongModuleName, as: Short
    #   # Short only available within MyModule
    # end
    #
    # Common aliasing patterns:
    #
    # Phoenix controller:
    # defmodule MyAppWeb.UserController do
    #   alias MyApp.Accounts
    #   alias MyApp.Accounts.User
    #
    #   def index(conn, _params) do
    #     users = Accounts.list_users()  # Instead of MyApp.Accounts.list_users()
    #     # ...
    #   end
    # end
    #
    # Context organization:
    # defmodule MyApp.SomeContext do
    #   alias MyApp.Repo
    #   alias MyApp.SomeContext.{Schema1, Schema2, Schema3}
    #   # Now can use Repo, Schema1, Schema2, Schema3 directly
    # end
    #
    # Conflict resolution:
    # alias MyApp.UserService, as: AppUserService
    # alias ExternalLib.UserService, as: ExtUserService
    # # Avoid naming conflicts
    #
    # Performance note: Aliases are compile-time only
    # No runtime overhead - they're just name transformations
  end

  def test_05_importing_functions do
    # CONCEPT: Function Import and Scope Management
    #
    # Import brings functions from another module into local scope,
    # allowing you to call them without module qualification.
    # Use sparingly to maintain code clarity.

    defmodule MathHelpers do
      def square(x), do: x * x
      def cube(x), do: x * x * x
    end

    defmodule Calculator do
      import MathHelpers

      def calculate do
        {square(4), cube(3)}
      end
    end

    {sq, cb} = Calculator.calculate()
    assert_equal(Enlightenment.__(), sq)

    assert_equal(Enlightenment.__(), cb)

    # Import strategies and best practices:
    #
    # Full import (use carefully):
    # import MyModule
    # # All public functions available without qualification
    #
    # Selective import:
    # import MyModule, only: [function1: 1, function2: 2]
    # import MyModule, except: [dangerous_function: 0]
    #
    # Import with guards (common pattern):
    # import Integer, only: [is_even: 1, is_odd: 1]
    # import Enum, only: [map: 2, filter: 2, reduce: 3]
    #
    # When to use import:
    #
    # ✅ Frequently used utility functions
    # ✅ DSL construction (macros)
    # ✅ Mathematical operations
    # ✅ Common transformations
    #
    # ❌ Avoid for:
    # - Rarely used functions
    # - Functions with common names (map, get, put)
    # - When module context provides meaning
    #
    # Import vs alias comparison:
    #
    # With alias:
    # alias MyApp.MathHelpers, as: Math
    # result = Math.square(4)  # Clear origin
    #
    # With import:
    # import MyApp.MathHelpers, only: [square: 1]
    # result = square(4)       # Direct call, but origin unclear
    #
    # Scope rules:
    # - Imports are module-scoped
    # - Can cause naming conflicts
    # - Always prefer explicit over implicit when in doubt
    #
    # Common import patterns:
    # import Ecto.Query, only: [from: 2]  # Database queries
    # import Phoenix.Controller, only: [redirect: 2, render: 3]  # Web
    # import ExUnit.Assertions, only: [assert: 1]  # Testing
  end

  def test_requiring_modules do
    # CONCEPT: Macro Requirements and Compile-Time Dependencies
    #
    # The 'require' directive makes macros available from another module.
    # Since macros are expanded at compile time, the module containing
    # them must be compiled first.

    # require is used for macros
    defmodule ConditionalExample do
      require Integer

      def check_number(n) do
        if Integer.is_even(n) do
          "even"
        else
          "odd"
        end
      end
    end

    assert_equal(Enlightenment.__(), ConditionalExample.check_number(4))

    assert_equal(Enlightenment.__(), ConditionalExample.check_number(7))

    # Require vs import distinction:
    #
    # require: Makes macros available
    # - Compile-time expansion
    # - Must be done before macro usage
    # - No impact on function calls
    #
    # import: Makes functions available without qualification
    # - Runtime function calls
    # - Can be done anywhere
    # - Affects function resolution
    #
    # Understanding macros and require:
    #
    # Macros are code that writes code:
    # - Expanded during compilation
    # - Generate Elixir AST
    # - Can inspect and transform arguments
    # - More powerful than functions
    #
    # Common modules that provide macros:
    #
    # Integer: is_even/1, is_odd/1 (guards)
    # Record: defrecord, extract (legacy)
    # ExUnit: test, describe, setup
    # Ecto.Query: from (query DSL)
    # GenServer: defcall, defcast (deprecated)
    #
    # Require patterns:
    #
    # For guard macros:
    # require Integer
    # def process(n) when Integer.is_even(n), do: :even
    #
    # For DSL macros:
    # require Logger
    # Logger.info("Message")  # Compile-time log level checking
    #
    # For test macros:
    # require ExUnit.Assertions
    # ExUnit.Assertions.assert(true)
    #
    # Automatic requiring:
    # Some modules are automatically required:
    # - Kernel (basic operators and constructs)
    # - Kernel.SpecialForms (def, defmodule, etc.)
    #
    # When in doubt:
    # If you get "undefined macro" error, you likely need require
    # If you get "undefined function" error, check imports/aliases
  end

  def test_module_documentation do
    # CONCEPT: Documentation as First-Class Feature
    #
    # Elixir treats documentation as a first-class feature, storing
    # it in module bytecode and making it available at runtime for
    # introspection and tool integration.

    defmodule DocumentedModule do
      @moduledoc "This module demonstrates documentation"

      @doc "This function says hello"
      def hello(name) do
        "Hello, #{name}!"
      end
    end

    assert_equal(Enlightenment.__(), DocumentedModule.hello("World"))

    # Documentation system features:
    #
    # Module documentation (@moduledoc):
    # - Describes the module's purpose
    # - Can include examples and usage
    # - Supports Markdown formatting
    # - Available via Code.fetch_docs/1
    #
    # Function documentation (@doc):
    # - Describes individual functions
    # - Can include type specs and examples
    # - Supports doctests
    # - Searchable and linkable
    #
    # Documentation best practices:
    #
    # Comprehensive module docs:
    # @moduledoc """
    # Provides authentication and authorization for users.
    #
    # This module handles:
    # - User registration and login
    # - Password hashing and verification
    # - Session management
    # - Role-based permissions
    #
    # ## Examples
    #
    #     iex> Auth.authenticate("user@example.com", "password")
    #     {:ok, %User{}}
    # """
    #
    # Detailed function docs:
    # @doc """
    # Authenticates a user with email and password.
    #
    # Returns `{:ok, user}` on success or `{:error, reason}` on failure.
    #
    # ## Examples
    #
    #     iex> authenticate("valid@email.com", "correct_password")
    #     {:ok, %User{email: "valid@email.com"}}
    #
    #     iex> authenticate("invalid@email.com", "wrong_password")
    #     {:error, :invalid_credentials}
    # """
    #
    # Type specifications with docs:
    # @spec authenticate(String.t(), String.t()) ::
    #   {:ok, User.t()} | {:error, atom()}
    #
    # Documentation tools integration:
    # - ExDoc: Generate HTML documentation
    # - IEx: h/1 helper for interactive docs
    # - Editor integration: Hover and completion
    # - Doctests: Executable documentation
    #
    # Special documentation attributes:
    # @moduledoc false  # Hide from documentation
    # @doc false        # Hide function from docs
    # @doc since: "1.2" # Version information
    # @deprecated "Use new_function/1 instead"
  end

  def test_08_module_introspection do
    # CONCEPT: Runtime Module Introspection and Reflection
    #
    # Elixir modules are first-class entities that can be introspected
    # at runtime. This enables powerful metaprogramming, debugging,
    # and tooling capabilities.

    defmodule IntrospectionExample do
      def public_function, do: :public
      defp private_function, do: :private
    end

    # Get module information
    functions = IntrospectionExample.__info__(:functions)

    # Check if public_function/0 is in the list
    assert_equal(Enlightenment.__(), {:public_function, 0} in functions)

    # Private functions are not in the :functions list
    assert_equal(Enlightenment.__(), {:private_function, 0} in functions)

    # Module introspection capabilities:
    #
    # __info__/1 provides various module details:
    # - :functions - List of public functions
    # - :macros - List of public macros
    # - :attributes - Module attributes
    # - :compile - Compilation information
    # - :md5 - Module checksum
    #
    # Introspection use cases:
    #
    # Dynamic function calling:
    # if {:start_link, 1} in MyModule.__info__(:functions) do
    #   MyModule.start_link(args)
    # end
    #
    # Behavior verification:
    # required_functions = [:init, :handle_call, :handle_cast]
    # module_functions = MyModule.__info__(:functions)
    # missing = required_functions -- Keyword.keys(module_functions)
    #
    # Development tooling:
    # # List all functions in a module
    # functions = MyModule.__info__(:functions)
    # Enum.each(functions, fn {name, arity} ->
    #   IO.puts("#{name}/#{arity}")
    # end)
    #
    # Testing and validation:
    # # Ensure module implements required interface
    # assert {:required_function, 2} in MyModule.__info__(:functions)
    #
    # Other introspection functions:
    #
    # Code.ensure_loaded?/1: Check if module is loaded
    # function_exported?/3: Check if function exists
    # macro_exported?/3: Check if macro exists
    # Code.fetch_docs/1: Get documentation
    #
    # Metaprogramming applications:
    # # Auto-generate delegate functions
    # for {name, arity} <- Target.__info__(:functions) do
    #   def unquote(name)(unquote_splicing(args)) do
    #     Target.unquote(name)(unquote_splicing(args))
    #   end
    # end
  end

  def test_use_directive do
    # CONCEPT: Code Injection and Module Extension
    #
    # The 'use' directive is Elixir's mechanism for code injection and
    # module extension. It executes the target module's __using__ macro,
    # which can inject functions, imports, attributes, and more.

    defmodule Usable do
      defmacro __using__(_opts) do
        quote do
          def greeting, do: "Hello from use!"
        end
      end
    end

    defmodule UsingModule do
      use Usable
    end

    assert_equal(Enlightenment.__(), UsingModule.greeting())

    # Understanding 'use' mechanics:
    #
    # When you write: use MyModule
    # Elixir calls: MyModule.__using__(options)
    # The returned AST is injected into the current module
    #
    # __using__ macro capabilities:
    # - Inject functions and macros
    # - Set module attributes
    # - Add imports, aliases, requires
    # - Implement behaviors
    # - Configure module settings
    #
    # Common 'use' patterns in Elixir ecosystem:
    #
    # GenServer:
    # use GenServer
    # # Injects: start_link/3, child_spec/1, and behavior
    #
    # Phoenix Controller:
    # use MyAppWeb, :controller
    # # Injects: import Phoenix.Controller, alias MyApp.Repo, etc.
    #
    # Ecto Schema:
    # use Ecto.Schema
    # # Injects: import Ecto.Changeset, schema/2 macro, etc.
    #
    # ExUnit Case:
    # use ExUnit.Case
    # # Injects: import ExUnit.Assertions, setup functions, etc.
    #
    # Creating reusable __using__ macros:
    #
    # defmodule MyApp.Controller do
    #   defmacro __using__(opts) do
    #     quote do
    #       import Phoenix.Controller
    #       import Plug.Conn
    #       alias MyApp.Repo
    #
    #       # Conditional injection based on options
    #       if unquote(opts[:auth]) do
    #         import MyApp.Auth
    #       end
    #     end
    #   end
    # end
    #
    # Advanced __using__ with options:
    # use MyModule, option: :value, flag: true
    # # Options passed to __using__ macro
    #
    # Benefits of 'use':
    # - Reduce boilerplate code
    # - Standardize module setup
    # - Create domain-specific languages
    # - Implement behavior patterns
    # - Share common functionality
    #
    # Use with caution:
    # - Makes code dependencies less explicit
    # - Can inject unexpected code
    # - Harder to trace function origins
    # - Consider alias/import first for simple cases
  end

  def test_module_callbacks do
    # CONCEPT: Compile-Time Hooks and Code Generation
    #
    # Module callbacks are hooks that execute during compilation,
    # enabling sophisticated metaprogramming and code generation
    # patterns. They provide precise control over the compilation process.

    defmodule CallbackExample do
      @before_compile __MODULE__

      defmacro __before_compile__(_env) do
        quote do
          def injected_function, do: "I was injected at compile time"
        end
      end
    end

    assert_equal(Enlightenment.__(), CallbackExample.injected_function())

    # Module callback types and timing:
    #
    # @before_compile: Just before module compilation finishes
    # @after_compile: After module compilation completes
    # @on_load: After module loading (runtime)
    # @external_resource: Track file dependencies
    #
    # Compilation lifecycle:
    # 1. Parse module definition
    # 2. Expand macros and evaluate attributes
    # 3. Execute @before_compile callbacks
    # 4. Generate final bytecode
    # 5. Execute @after_compile callbacks
    # 6. Module available for use
    # 7. Execute @on_load when first accessed
    #
    # @before_compile use cases:
    #
    # Code generation based on accumulated data:
    # defmodule RouteBuilder do
    #   @routes []
    #
    #   defmacro route(path, handler) do
    #     quote do
    #       @routes [{unquote(path), unquote(handler)} | @routes]
    #     end
    #   end
    #
    #   @before_compile __MODULE__
    #
    #   defmacro __before_compile__(_env) do
    #     routes = Module.get_attribute(__CALLER__.module, :routes)
    #     generate_route_functions(routes)
    #   end
    # end
    #
    # Validation and checks:
    # defmodule ValidatedBehaviour do
    #   @before_compile __MODULE__
    #
    #   defmacro __before_compile__(env) do
    #     required_functions = [:init, :handle]
    #     defined = Module.definitions_in(env.module, :def)
    #
    #     missing = required_functions -- Keyword.keys(defined)
    #     if missing != [] do
    #       raise CompileError, description: "Missing functions: #{inspect(missing)}"
    #     end
    #   end
    # end
    #
    # @after_compile applications:
    # - Register modules with global registry
    # - Emit compile-time metrics
    # - Validate generated code
    # - Trigger dependent compilation
    #
    # @on_load scenarios:
    # - Initialize native libraries
    # - Load configuration
    # - Establish connections
    # - Validate runtime environment
    #
    # Environment information available:
    # %{
    #   module: MyModule,        # Current module
    #   file: "lib/my_module.ex", # Source file
    #   line: 42,               # Current line
    #   function: {:my_func, 2}, # Current function
    #   context: :guard         # Context (guard, match, etc.)
    # }
    #
    # Best practices:
    # - Keep callbacks simple and fast
    # - Handle errors gracefully
    # - Document callback behavior
    # - Consider compilation time impact
    # - Test callback edge cases
  end
end
