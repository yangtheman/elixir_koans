#!/usr/bin/env elixir

# The path to Elixir Enlightenment starts with the following:

Code.require_file("lib/enlightenment.ex")

# Basic concepts
Code.require_file("lib/about_asserts.ex")
Code.require_file("lib/about_truth_and_false.ex")
Code.require_file("lib/about_atoms.ex")
Code.require_file("lib/about_numbers.ex")
Code.require_file("lib/about_strings.ex")

# Collections
Code.require_file("lib/about_lists.ex")
Code.require_file("lib/about_tuples.ex")
Code.require_file("lib/about_maps.ex")
Code.require_file("lib/about_keyword_lists.ex")

# Core concepts
Code.require_file("lib/about_pattern_matching.ex")
Code.require_file("lib/about_functions.ex")
Code.require_file("lib/about_enumeration.ex")
Code.require_file("lib/about_pipe_operator.ex")

# Advanced concepts
Code.require_file("lib/about_modules.ex")
Code.require_file("lib/about_structs.ex")
Code.require_file("lib/about_control_flow.ex")
Code.require_file("lib/about_processes.ex")

# Define the path to enlightenment
koans = [
  AboutAsserts,
  AboutTruthAndFalse,
  AboutAtoms,
  AboutNumbers,
  AboutStrings,
  AboutLists,
  AboutTuples,
  AboutMaps,
  AboutKeywordLists,
  AboutPatternMatching,
  AboutFunctions,
  AboutEnumeration,
  AboutPipeOperator,
  AboutModules,
  AboutStructs,
  AboutControlFlow,
  AboutProcesses
]

# Walk the path
Enlightenment.ThePath.walk(koans)
