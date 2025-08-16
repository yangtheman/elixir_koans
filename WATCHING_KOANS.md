# Auto-Running Koans

This document explains different ways to automatically re-run the Elixir Koans when you make changes to the koan files.

## Method 1: Simple File Watcher (Recommended)

```bash
elixir simple_watch.exs
```

**Features:**
- Very simple implementation
- Checks every 2 seconds
- Uses file checksums to detect changes
- Most compatible across systems

## Method 2: Interactive Runner

```bash
elixir run_koans_interactive.exs
```

**Features:**
- Manual control - press ENTER to run
- Type 'q' to quit
- Good for step-by-step learning
- No automatic file watching

## Method 3: fswatch (External Tool)

First install fswatch:
```bash
# macOS
brew install fswatch

# Ubuntu/Debian  
sudo apt-get install fswatch
```

Then run:
```bash
./watch_koans_fswatch.sh
```

**Features:**
- Very fast and efficient
- Uses system-level file watching
- Requires external installation

## Method 4: Manual Running

The traditional way:
```bash
elixir path_to_enlightenment.exs
```

Run this command each time you want to test your changes.

## Which Method Should I Use?

**For most users**: Use Method 1 (`elixir simple_watch.exs`) - it provides good compatibility and simplicity.

**For learning control**: Use Method 2 (`elixir run_koans_interactive.exs`) - gives you full control over when tests run.

**For advanced users**: Use Method 3 (fswatch) - most efficient but requires tool installation.

## Tips

- All auto-run methods will show a progress bar and stop at the first failing test
- Make sure to save your files after making changes
- Use Ctrl+C to stop any of the watching scripts
- The watchers only monitor files in the `lib/` directory ending with `.ex`
