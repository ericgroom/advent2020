defmodule Advent2020.Parser do
  def parse_intlist(raw) do
    raw
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_grid(raw, elem_parser) when is_function(elem_parser, 1) do
    raw
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn row ->
      Enum.map(row, elem_parser)
    end)
  end
end
