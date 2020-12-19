defmodule Advent2020.Days.Day18 do
  use Advent2020.Day, day: 18

  def part_one do
    @input
    |> parse()
    |> Enum.map(&build_ast/1)
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  def part_two do
    @input
    |> parse()
    |> Enum.map(&build_add_ast/1)
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  def build_add_ast(x) when is_integer(x), do: x
  def build_add_ast([x]) when is_integer(x), do: x
  def build_add_ast(x) when is_tuple(x), do: x
  def build_add_ast([x]) when is_tuple(x), do: x
  def build_add_ast(tokens) do
    {first_operand, rest} = take_operand(tokens)
    first_operand = build_add_ast(first_operand)
    if rest == [] do
      first_operand
    else
      {op, rest} = take_operator(rest)
      {second_operand, rest} = case op do
        :+ -> take_operand(rest)
        :* -> take_operand_until_mult(rest)
      end
      second_operand = build_add_ast(second_operand)
      expr = {op, first_operand, second_operand}
      build_add_ast([expr | rest])
    end
  end

  def build_ast(x) when is_integer(x), do: x
  def build_ast(x) when is_tuple(x), do: x
  def build_ast([x]) when is_tuple(x), do: x
  def build_ast(tokens) do
    # take two "operands", build a tree, nest that tree in the next expression
    {first_operand, rest} = take_operand(tokens)
    first_operand = build_ast(first_operand)
    {op, rest} = take_operator(rest)
    {second_operand, rest} = take_operand(rest)
    second_operand = build_ast(second_operand)
    expr = {op, first_operand, second_operand}
    build_ast([expr | rest])
  end

  defp take_operand_until_mult(tokens, so_far \\ [])
  defp take_operand_until_mult([], so_far), do: {so_far, []}
  defp take_operand_until_mult([x], so_far), do: {so_far ++ [x], []}
  defp take_operand_until_mult([x | rest], so_far) when x == :open do
    {inter_parens_tokens, rest} = take_parens([x | rest])
    with_parens_tokens = [:open | inter_parens_tokens] ++ [:close]
    take_operand_until_mult(rest, so_far ++ with_parens_tokens)
  end
  defp take_operand_until_mult([x | rest], so_far) when x == :*, do: {so_far, [x | rest]}
  defp take_operand_until_mult([x | rest], so_far), do: take_operand_until_mult(rest, so_far ++ [x])

  defp take_operand([x | rest]) when is_tuple(x), do: {x, rest}
  defp take_operand([x | rest]) when is_integer(x), do: {x, rest}
  defp take_operand([x | rest]) when x == :open do
    {in_parens, rest} = take_parens([x | rest])
    {in_parens, rest}
  end
 
  defp take_operator([:+ | rest]), do: {:+, rest}
  defp take_operator([:* | rest]), do: {:*, rest}
  defp take_operator([x | rest]), do: {x, rest}

  defp take_parens(tokens, so_far \\ [], counter \\ 0)
  defp take_parens([:close | rest], so_far, 1), do: {so_far, rest}
  defp take_parens([:close | rest], so_far, x), do: take_parens(rest, so_far ++ [:close], x-1)
  defp take_parens([:open | rest], so_far, 0), do: take_parens(rest, so_far, 1)
  defp take_parens([:open | rest], so_far, x), do: take_parens(rest, so_far ++ [:open], x+1)
  defp take_parens([x | rest], so_far, counter), do: take_parens(rest, so_far ++ [x], counter)

  def eval(x) when is_integer(x), do: x
  def eval({:+, x, y}), do: eval(x) + eval(y)
  def eval({:*, x, y}), do: eval(x) * eval(y)

  def parse(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_expr/1)
  end

  def parse_expr(raw) do
    raw
    |> String.graphemes()
    |> Stream.map(fn
      " " -> nil
      "+" -> :+
      "*" -> :*
      "(" -> :open
      ")" -> :close
      x -> int!(x) # input only seems to be single digits, probably for easier parsing
    end)
    |> Enum.filter(fn x -> not is_nil(x) end)
  end

  defp int!(x) do
    {x, ""} = Integer.parse(x)
    x
  end
end
