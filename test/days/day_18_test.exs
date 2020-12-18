defmodule Advent2020.Days.Day18Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day18

  describe "summed output" do
    test "real input" do
      assert part_one() == 8298263963837
    end
  end

  describe "eval/1" do
    test "manual AST sanity check" do
      # 1 + 2
      ast = {:+, 1, 2}
      assert eval(ast) == 3
    end

    test "manual AST larger sanity check" do
      # 1 + 2 * 3 + 4 * 5 + 6
      first = {:+, 1, 2}
      second = {:*, first, 3}
      third = {:+, second, 4}
      fourth = {:*, third, 5}
      fifth = {:+, fourth, 6}
      assert eval(fifth) == 71
    end

    test "manual AST parens" do
      # 1 + (2 * 3) + (4 * (5 + 6))
      first = {:+, 5, 6}
      second = {:*, 4, first}
      third = {:*, 2, 3}
      fourth = {:+, 1, third}
      fifth = {:+, fourth, second}
      assert eval(fifth) == 51
    end
  end

  describe "build_ast/1" do
    test "manual sanity check" do
      tokens = [1, :+, 2]
      assert build_ast(tokens) == {:+, 1, 2}
    end

    test "larger sanity check" do
      tokens = [1, :+, 2, :*, 3]
      assert build_ast(tokens) == {:*, {:+, 1, 2}, 3}
    end

    test "parens sanity check" do
      tokens = [1, :+, :open, 2, :*, 3, :close, :+, :open, 4, :*, :open, 5, :+, 6, :close, :close]
      first = {:+, 5, 6}
      second = {:*, 4, first}
      third = {:*, 2, 3}
      fourth = {:+, 1, third}
      expected_ast = {:+, fourth, second}
      assert build_ast(tokens) == expected_ast
    end
  end

  describe "parse_expr/1" do
    test "sanity check" do
      raw = "1 + (2 * 3) + (4 * (5 + 6))"
      tokens = [1, :+, :open, 2, :*, 3, :close, :+, :open, 4, :*, :open, 5, :+, 6, :close, :close]
      assert parse_expr(raw) == tokens
    end
  end
end
