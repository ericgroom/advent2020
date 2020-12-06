defmodule Advent2020.Days.Day6 do
  use Advent2020.Day, day: 6

  def part_one do
    @input
    |> parse()
    |> Enum.map(&declaration_for_group/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def parse(raw) do
    raw
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
    end)
  end

  def declaration_for_group(group) do
    group
    |> List.flatten()
    |> Enum.into(MapSet.new())
  end
end
