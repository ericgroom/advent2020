defmodule Advent2020.Days.Day6 do
  use Advent2020.Day, day: 6

  def part_one do
    @input
    |> parse()
    |> Enum.map(fn group -> declaration_for_group(group, &anyone_combinator/1) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def part_two do
    @input
    |> parse()
    |> Enum.map(fn group -> declaration_for_group(group, &everyone_combinator/1) end)
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

  def declaration_for_group(group, combinator) do
    group
    |> Enum.map(&MapSet.new/1)
    |> combinator.()
  end

  def anyone_combinator(people) do
    people
    |> Enum.reduce(&MapSet.union/2)
  end

  def everyone_combinator(people) do
    people
    |> Enum.reduce(&MapSet.intersection/2)
  end
end
