#!/usr/bin/env elixir

# Demo: How the Elixir Koans Work
# Run with: elixir demo.exs

IO.puts("\n🧘 Welcome to the Elixir Koans Demo! 🧘\n")

IO.puts("The Elixir Koans teach you Elixir through failing tests.")
IO.puts("Here's how it works:\n")

IO.puts("1. You start with broken tests like this:")
IO.puts("   assert Enlightenment.__() == true")
IO.puts("   # The __ needs to be replaced with the correct answer")

IO.puts("\n2. When you run the koans, you get helpful feedback:")
IO.puts("   - Which file to look at")
IO.puts("   - What line number")
IO.puts("   - A zen-like message")
IO.puts("   - Your progress")

IO.puts("\n3. You fix one test at a time and learn Elixir concepts:")
IO.puts("   - Atoms (:hello)")
IO.puts("   - Pattern matching [head | tail] = [1, 2, 3]")
IO.puts("   - Functions and modules")
IO.puts("   - Processes and concurrency")
IO.puts("   - And much more!")

IO.puts("\n📚 Your journey covers 17 koan modules:")

koans = [
  "about_asserts.ex - Testing fundamentals",
  "about_truth_and_false.ex - Boolean logic",
  "about_atoms.ex - Elixir's constants",
  "about_numbers.ex - Numeric operations",
  "about_strings.ex - String manipulation",
  "about_lists.ex - List operations",
  "about_tuples.ex - Fixed-size collections",
  "about_maps.ex - Key-value data",
  "about_keyword_lists.ex - Special lists",
  "about_pattern_matching.ex - Elixir's superpower",
  "about_functions.ex - Function definitions",
  "about_enumeration.ex - Working with collections",
  "about_pipe_operator.ex - Data transformation pipeline",
  "about_modules.ex - Code organization",
  "about_structs.ex - Structured data",
  "about_control_flow.ex - if, case, cond",
  "about_processes.ex - Concurrency model"
]

koans
|> Enum.with_index(1)
|> Enum.each(fn {koan, index} ->
  IO.puts("   #{index |> to_string |> String.pad_leading(2)}. #{koan}")
end)

IO.puts("\n🚀 Ready to start your journey?")
IO.puts("Run: elixir path_to_enlightenment.exs")
IO.puts("\n🎯 Goal: Replace all Enlightenment.__() placeholders with correct answers")
IO.puts("💡 Total tests: 223")
IO.puts("🏆 Reward: Deep understanding of Elixir")

IO.puts("\n✨ May your path be enlightened! ✨")
IO.puts("Mountains are merely mountains...")
