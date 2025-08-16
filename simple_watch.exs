#!/usr/bin/env elixir

defmodule SimpleKoanWatcher do
  @moduledoc """
  Simple file watcher for Elixir Koans that doesn't require external dependencies.

  Usage: elixir simple_watch.exs
  """

  def start do
    IO.puts("\n🔍 Simple Koan Watcher")
    IO.puts("Checks for file changes every 2 seconds...")
    IO.puts("Press Ctrl+C to stop.\n")

    # Run koans initially
    run_koans()

    # Start watching loop
    watch_loop(get_checksums())
  end

  defp watch_loop(old_checksums) do
    # Check every 2 seconds
    :timer.sleep(2000)

    new_checksums = get_checksums()

    if new_checksums != old_checksums do
      IO.puts("\n📝 File changes detected!")
      run_koans()
      watch_loop(new_checksums)
    else
      watch_loop(old_checksums)
    end
  end

  defp get_checksums do
    Path.wildcard("lib/about_*.ex")
    |> Enum.map(fn file ->
      case File.read(file) do
        {:ok, content} -> {file, :erlang.crc32(content)}
        _ -> {file, nil}
      end
    end)
    |> Map.new()
  end

  defp run_koans do
    # Clear screen
    IO.write("\e[H\e[2J")

    IO.puts("🧘 Running Elixir Koans...")
    IO.puts("=" |> String.duplicate(50))

    try do
      # Load and run the koans
      {_result, _binding} = Code.eval_file("path_to_enlightenment.exs")
    rescue
      error ->
        IO.puts("❌ Error: #{inspect(error)}")
    end

    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("🔍 Watching for changes... (checking every 2 seconds)")
    IO.puts("💾 Save any koan file to automatically re-run")
    IO.puts(String.duplicate("=", 60))
  end
end

SimpleKoanWatcher.start()
