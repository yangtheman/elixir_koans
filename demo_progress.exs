# Simple test to demonstrate the framework working correctly
Code.require_file("lib/enlightenment.ex")

defmodule WorkingTest do
  import Enlightenment

  def test_first_passes do
    assert true
  end

  def test_second_passes do
    assert_equal(2, 1 + 1)
  end

  def test_third_passes do
    assert_equal("hello", "hello")
  end

  def test_this_one_fails do
    assert Enlightenment.__()
  end
end

# Test with one failing test after several passing ones
Enlightenment.ThePath.walk([WorkingTest])
