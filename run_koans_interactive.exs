#!/usr/bin/env elixir

defmodule KoanRunner do
  @moduledoc """
  Interactive koan runner that waits for user input to re-run tests.

  Usage: elixir run_koans_interactive.exs

  This provides a simple way to re-run koans by pressing Enter.
  """

  def start do
    IO.puts("\n🧘 Interactive Koan Runner")
    IO.puts("=" |> String.duplicate(50))
    IO.puts("Press ENTER to run koans, 'q' to quit\n")

    run_loop()
  end

  defp run_loop do
    # Run koans
    run_koans()

    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("Press ENTER to run again, or 'q' + ENTER to quit:")

    case IO.gets("") |> String.trim() do
      "q" ->
        IO.puts("👋 Happy learning!")
        System.halt(0)

      _ ->
        run_loop()
    end
  end

  defp run_koans do
    # Clear screen for better visibility
    IO.write("\e[H\e[2J")

    IO.puts("🔄 Running Elixir Koans...")
    IO.puts(String.duplicate("=", 30))

    try do
      Code.eval_file("path_to_enlightenment.exs")
    rescue
      e ->
        IO.puts("Error running koans: #{inspect(e)}")
    end
  end
end

# Start the interactive runner
KoanRunner.start()
