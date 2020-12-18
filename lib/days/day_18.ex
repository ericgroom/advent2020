defmodule Advent2020.Days.Day18 do
  use Advent2020.Day, day: 18

  # stack based aside from parens
  # could be represented as nested lists?
  # how to represent operators?
  # tree of tuples
  # {1, "*", 2}
  # {1, "+", {{2, "*", 3}}}
  # follow elixir
  # {:+, [1, {:*, [2, 3]}]}

  def eval(x) when is_integer(x), do: x
  def eval({:+, args}), do: Enum.map(args, &eval/1) |> Enum.reduce(0, &+/2)
  def eval({:*, args}), do: Enum.map(args, &eval/1) |> Enum.reduce(1, &*/2)
end
