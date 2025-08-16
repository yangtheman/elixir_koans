# Elixir Koans

The Elixir Koans walk you along the path to enlightenment in order to learn Elixir.
The goal is to learn the Elixir language, syntax, structure, and some common
functions and libraries. We also teach you culture by basing the koans on tests.
Testing is not just something we pay lip service to, but something we
live. Testing is essential in your quest to learn and do great things in Elixir.

## The Structure

The koans are broken out into areas by file, lists are covered in `about_lists.ex`,
modules are introduced in `about_modules.ex`, *etc*. They are presented in
order in the `path_to_enlightenment.exs` file.

Each koan builds up your knowledge of Elixir and builds upon itself. It will stop at
the first place you need to correct.

Some koans simply need to have the correct answer substituted for an incorrect one.
Some, however, require you to supply your own answer. If you see the method `__` (a
double underscore) listed, it is a hint to you to supply your own code in order to
make it work correctly.

## Installing Elixir

If you do not have Elixir setup, please visit [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html) for
operating specific instructions. In order to run the koans you need `elixir` installed. 
To check your installation simply type:

Unix platforms from any terminal window:

    $ elixir --version

Windows from the command prompt (`cmd.exe`)

    c:\> elixir --version

Any response for Elixir with a version number greater than 1.12 is fine.

## Running the Koans

You can run the tests by calling the main file directly:

Unix platforms, from the `elixir_koans` directory

    [elixir_koans] $ elixir path_to_enlightenment.exs

Windows is the same thing

    c:\elixir_koans> elixir path_to_enlightenment.exs

### Continuous Testing (Auto-run on file changes)

For a smoother learning experience, you can have the koans automatically re-run when you save changes.

**Available Options:**
- `elixir simple_watch.exs` - Simple version (checks every 2 seconds)
- `elixir run_koans_interactive.exs` - Manual control (press ENTER to run)
- `./watch_koans_fswatch.sh` - Uses fswatch (requires installation)

📖 **See [WATCHING_KOANS.md](WATCHING_KOANS.md) for detailed instructions on all auto-run options.**

### Red, Green, Refactor

In test-driven development the mantra has always been *red, green, refactor*.
Write a failing test and run it (*red*), make the test pass (*green*),
then look at the code and consider if you can make it any better (*refactor*).

While walking the path to Elixir enlightenment you will need to run the koan and
see it fail (*red*), make the test pass (*green*), then take a moment
and reflect upon the test to see what it is teaching you and improve the code to
better communicate its intent (*refactor*).

The very first time you run the koans you will see the following output:

    $ elixir path_to_enlightenment.exs
    
    AboutAsserts#test_assert_truth has damaged your karma.
    
    The Master says:
      You have not yet reached enlightenment.
    
    The answers you seek...
    Expected false to be truthy
    
    Please meditate on the following code:
    lib/about_asserts.ex:10
    
    mountains are merely mountains
    your path thus far [X_________________________________________________] 0/280 (0%)

You have come to your first stage. Notice it is telling you where to look for
the first solution:

    Please meditate on the following code:
    lib/about_asserts.ex:10

Open the `lib/about_asserts.ex` file and look at the first test:

    # We shall contemplate truth by testing reality, via asserts.
    def test_assert_truth do
      assert __ # This should be true
    end

Change the `__` to `true` and re-run the test. After you are
done, think about what you are learning. In this case, ignore everything except
the function name (`test_assert_truth`) and the parts inside the function (everything
before the `end`).

In this case the goal is for you to see that if you pass a value to the `assert`
macro, it will either ensure it is truthy and continue on, or fail if the value is falsy.

## Concepts Covered

The Elixir Koans cover these essential Elixir concepts:

- **Basic Data Types**: Atoms, numbers, strings, booleans
- **Collections**: Lists, tuples, maps, keyword lists
- **Pattern Matching**: The heart of Elixir
- **Functions**: Anonymous functions, named functions, guards
- **Modules and Structs**: Code organization
- **Control Flow**: Case, cond, if/unless, with
- **Comprehensions**: List and map comprehensions
- **Processes**: The Actor model, spawn, send, receive
- **GenServer**: OTP fundamentals
- **Protocols**: Polymorphism in Elixir
- **Pipe Operator**: The |> operator
- **Error Handling**: try/catch/rescue
- **Metaprogramming**: Macros and AST
- **Behaviours**: Defining contracts

## Inspiration

A special thanks to the Ruby Koans project by EdgeCase for inspiring this
project. The Ruby Koans taught us the value of learning through failing tests
and the importance of contemplation in the learning process.

## Other Resources

- **The Elixir Language**: [https://elixir-lang.org](https://elixir-lang.org)
- **Elixir Getting Started Guide**: [https://elixir-lang.org/getting-started/introduction.html](https://elixir-lang.org/getting-started/introduction.html)
- **Programming Elixir**: [https://pragprog.com/titles/elixir16/programming-elixir-1-6/](https://pragprog.com/titles/elixir16/programming-elixir-1-6/)
- **Elixir in Action**: [https://www.manning.com/books/elixir-in-action-second-edition](https://www.manning.com/books/elixir-in-action-second-edition)

## License

Elixir Koans is released under the MIT License. See LICENSE for details.
