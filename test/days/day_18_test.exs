defmodule Advent2020.Days.Day18Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day18

  describe "eval/1" do
    test "manual AST sanity check" do
      # 1 + 2
      ast = {:+, [1, 2]}
      assert eval(ast) == 3
    end

    test "manual AST larger sanity check" do
      # 1 + 2 * 3 + 4 * 5 + 6
      first = {:+, [1, 2]}
      second = {:*, [first, 3]}
      third = {:+, [second, 4]}
      fourth = {:*, [third, 5]}
      fifth = {:+, [fourth, 6]}
      assert eval(fifth) == 71
    end

    test "manual AST parens" do
      # 1 + (2 * 3) + (4 * (5 + 6))
      first = {:+, [5, 6]}
      second = {:*, [4, first]}
      third = {:*, [2, 3]}
      fourth = {:+, [1, third]}
      fifth = {:+, [fourth, second]}
      assert eval(fifth) == 51
    end
  end
end
