# Simple test to see if our framework is working
Code.require_file("lib/enlightenment.ex")

defmodule SimpleTest do
  import Enlightenment

  def test_works do
    assert true
  end

  def test_fails do
    assert Enlightenment.__()
  end
end

# Test just one module
Enlightenment.ThePath.walk([SimpleTest])
