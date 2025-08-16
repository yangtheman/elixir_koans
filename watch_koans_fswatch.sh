#!/bin/bash

# Simple file watcher for Elixir Koans using fswatch
# Usage: ./watch_koans_fswatch.sh
# 
# This script requires fswatch to be installed:
# - macOS: brew install fswatch  
# - Ubuntu/Debian: sudo apt-get install fswatch
# - Other systems: check fswatch documentation

echo "🔍 Koan Watcher (fswatch version) started!"
echo "Watching for changes in lib/*.ex files..."
echo "Press Ctrl+C to stop."
echo ""

# Function to run koans
run_koans() {
    clear
    echo "🔄 Running koans..."
    echo "=================="
    elixir path_to_enlightenment.exs
    echo ""
    echo "============================================================"
    echo "💡 Save any .ex file in lib/ to automatically re-run tests"
    echo "============================================================"
}

# Run koans initially
run_koans

# Check if fswatch is available
if ! command -v fswatch &> /dev/null; then
    echo "❌ fswatch not found. Please install it:"
    echo "   macOS: brew install fswatch"
    echo "   Ubuntu: sudo apt-get install fswatch"
    echo ""
    echo "Alternatively, use: elixir watch_koans.exs"
    exit 1
fi

# Watch for file changes and run koans
fswatch -o lib/*.ex | while read f; do
    run_koans
done
