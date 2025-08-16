# Test just the new koans to make sure they work
Code.require_file("lib/enlightenment.ex")
Code.require_file("lib/about_keyword_lists.ex")
Code.require_file("lib/about_enumeration.ex")
Code.require_file("lib/about_pipe_operator.ex")
Code.require_file("lib/about_structs.ex")

# Test just the new modules (ordered from easy to hard, matching path_to_enlightenment.exs)
new_koans = [
  AboutKeywordLists,
  AboutEnumeration,
  AboutPipeOperator,
  AboutStructs
]

Enlightenment.ThePath.walk(new_koans)
