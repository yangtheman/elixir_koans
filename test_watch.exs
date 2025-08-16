#!/usr/bin/env elixir

defmodule TestWatcher do
  def test do
    IO.puts("Testing file watching mechanism...")

    # Get initial file times
    IO.puts("Getting initial file times...")
    initial_times = get_file_times()
    IO.inspect(initial_times, label: "Initial times")

    IO.puts("\nNow modify a file in lib/ and press Enter...")
    IO.gets("")

    # Get new file times
    IO.puts("Getting new file times...")
    new_times = get_file_times()
    IO.inspect(new_times, label: "New times")

    # Find changed files
    changed = find_changed_files(initial_times, new_times)
    IO.puts("\nChanged files: #{inspect(changed)}")
  end

  defp get_file_times do
    files = Path.wildcard("lib/*.ex")

    files
    |> Enum.map(fn file ->
      case File.stat(file) do
        {:ok, %{mtime: mtime}} ->
          mtime_seconds = :calendar.datetime_to_gregorian_seconds(mtime)
          {file, mtime_seconds}

        {:error, _} ->
          {file, 0}
      end
    end)
    |> Enum.into(%{})
  end

  defp find_changed_files(old_times, new_times) do
    new_times
    |> Enum.filter(fn {file, new_time} ->
      old_time = Map.get(old_times, file, 0)
      new_time != old_time and new_time > old_time
    end)
    |> Enum.map(fn {file, _} -> Path.basename(file) end)
  end
end

TestWatcher.test()
