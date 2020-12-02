defmodule Advent2020.Parser do
  def parse_intlist(raw) do
    raw
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
