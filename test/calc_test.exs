# HW 04 : Calculator in Elixir (Test Functions)
# The code is implemented  as test functions for calc.ex and calls eval, calculateResult method and asserts the output
# References taken for learning Elixir testing:
# https://elixirschool.com/en/lessons/basics/testing/

defmodule Calc_test do
  use ExUnit.Case
  doctest Calc

  test "testExampleAdd" do
    input = "2 + 3"
    assert Calc.eval(input) == "5"
  end

  test "testExampleMul" do
    input = "5 * 1"
    assert Calc.eval(input) == "5"
  end

  test "testExampleSub" do
    input = "20 - 4"
    assert Calc.eval(input) == "16"
  end

  test "testExampleDiv" do
    input = "20 / 4"
    assert Calc.eval(input) == "5"
  end

  test "testExampleParan" do
    input = "24 / 6 + (5 - 4)"
    assert Calc.eval(input) == "5"
  end

  test "testExamplePrecedence" do
    input = "1 + 3 * 3 + 1"
    assert Calc.eval(input) == "11"
  end

  test "testCalculationFunctionMul" do
    assert Calc.calculateResult("2", "*", "2") =="4"
  end

  test "testCalculationFunctionAdd" do
    assert Calc.calculateResult("2", "+", "9") =="11"
  end

  test "testCalculationFunctionSub" do
    assert Calc.calculateResult("2", "-", "2") =="0"
  end

  test "testCalculationFunctionDiv" do
    assert Calc.calculateResult("8", "/", "2") =="4"
  end

end
