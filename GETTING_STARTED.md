# Elixir Koans Setup Guide

## Quick Start

1. **Clone the repository** (or download the files):
   ```bash
   git clone <repository-url>
   cd elixir_koans
   ```

2. **Make sure you have Elixir installed** (version 1.12 or later):
   ```bash
   elixir --version
   ```
   
   If you don't have Elixir installed, visit [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html)

3. **Start your journey to enlightenment**:
   ```bash
   elixir path_to_enlightenment.exs
   ```

## Your First Steps

When you first run the koans, you'll see something like:

```
Elixir.AboutAsserts#test_assert_truth has damaged your karma.

The Master says:
  You have not yet reached enlightenment.

The answers you seek...
Please replace __ with the correct answer

Please meditate on the following code:
unknown:0

mountains are merely mountains
your path thus far [X_________________________________________________] 0/280 (0%)
```

This tells you:
- Which test is failing: `AboutAsserts#test_assert_truth`
- What's wrong: You need to replace `__` with the correct answer
- Your progress: 0 out of 280 tests passing

## How to Fix Your First Koan

1. **Open `lib/about_asserts.ex`** in your text editor
2. **Look for the failing test**:
   ```elixir
   def test_assert_truth do
     # This should be true
     assert Enlightenment.__()
   end
   ```
3. **Replace `Enlightenment.__()` with `true`**:
   ```elixir
   def test_assert_truth do
     # This should be true
     assert true
   end
   ```
4. **Run the koans again**:
   ```bash
   elixir path_to_enlightenment.exs
   ```

You should now see the test pass and move on to the next failing test!

## The Path to Enlightenment

The koans are structured to teach you Elixir concepts in this order:

1. **AboutAsserts** - Learn how testing works
2. **AboutTruthAndFalse** - Understand truthiness in Elixir
3. **AboutAtoms** - Learn about atoms (symbols)
4. **AboutNumbers** - Work with numbers and math
5. **AboutStrings** - String manipulation
6. **AboutLists** - The most common data structure
7. **AboutTuples** - Fixed-size collections
8. **AboutMaps** - Key-value data structures
9. **AboutPatternMatching** - The heart of Elixir
10. **AboutFunctions** - Functions and higher-order programming
11. **AboutModules** - Code organization
12. **AboutControlFlow** - if/case/cond/with statements
13. **AboutProcesses** - The Actor model and concurrency

## Tips for Success

1. **Read the comments** - They contain valuable information
2. **Run the koans after each change** - See your progress immediately
3. **Experiment** - Try different values to understand the concepts
4. **Don't just fill in blanks** - Think about why each answer is correct
5. **Look up documentation** - Use [https://hexdocs.pm/elixir/](https://hexdocs.pm/elixir/) when stuck

## Common Placeholders

- `Enlightenment.__()` - Replace with the correct value
- `Enlightenment._n_()` - Replace with the correct number
- `Enlightenment._s_()` - Replace with the correct string

## Getting Help

If you get stuck:
1. Read the test name and comments carefully
2. Look at the error message for clues
3. Try the Elixir documentation: [https://hexdocs.pm/elixir/](https://hexdocs.pm/elixir/)
4. Experiment in an Elixir shell: `iex`

## Troubleshooting

**"Command not found: elixir"**
- Install Elixir from [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html)

**Syntax errors when running**
- Make sure you haven't introduced syntax errors when editing files
- Check that parentheses and quotes are balanced

**Tests aren't progressing**
- Make sure you're replacing the placeholders with actual values, not keeping them as `Enlightenment.__()`

## Congratulations!

When you complete all the koans, you'll see a beautiful ASCII art congratulations screen. You'll have learned the fundamentals of Elixir and be ready to build real applications!

Happy coding, and may you achieve Elixir enlightenment! 🧘‍♂️✨
