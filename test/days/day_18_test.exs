defmodule Advent2020.Days.Day18Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day18

  describe "summed output" do
    test "real input part one" do
      assert part_one() == 8298263963837
    end

    test "real input part two" do
      assert part_two() == 145575710203332
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

  describe "build_add_ast/1" do
    test "sanity check" do
      tokens = [1, :+, 2, :*, 3, :+, 4, :*, 5, :+, 6]
      first = {:+, 1, 2}
      second = {:+, 3, 4}
      third = {:+, 5, 6}
      fourth = {:*, first, second}
      fifth = {:*, fourth, third}
      assert build_add_ast(tokens) == fifth
    end

    test "parens sanity check" do
      tokens = [1, :+, :open, 2, :*, 3, :close, :+, :open, 4, :*, :open, 5, :+, 6, :close, :close]
      first = {:+, 5, 6}
      second = {:*, 4, first}
      third = {:*, 2, 3}
      fourth = {:+, 1, third}
      expected_ast = {:+, fourth, second}
      assert build_add_ast(tokens) == expected_ast
    end

    test "eval samples" do
      assert "1 + (2 * 3) + (4 * (5 + 6))"
        |> parse_expr()
        |> build_add_ast()
        |> eval()
        == 51

      assert "2 * 3 + (4 * 5)"
        |> parse_expr()
        |> build_add_ast()
        |> IO.inspect()
        |> eval()
        == 46

      assert "5 + (8 * 3 + 9 + 3 * 4 * 3)"
        |> parse_expr()
        |> build_add_ast()
        |> eval()
        == 1445

      assert "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
        |> parse_expr()
        |> build_add_ast()
        |> eval()
        == 669060

      assert "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
        |> parse_expr()
        |> build_add_ast()
        |> eval()
        == 23340
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
