defmodule Advent2020.Days.Day3 do
  use Advent2020.Day, day: 3

  alias Advent2020.DataStructures.{CycledGrid, Vec2D}

  def part_one do
    @input
    |> parse()
    |> count_trees({3, 1})
  end

  def part_two do
    @input
    |> parse()
    |> count_all_slopes()
  end

  def parse(raw) do
    raw
    |> Parser.parse_grid(&parse_space/1)
    |> CycledGrid.new()
  end

  defp parse_space("#"), do: :tree
  defp parse_space("."), do: :empty

  def count_all_slopes(%CycledGrid{} = grid) do
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    slopes
    |> Enum.map(&count_trees(grid, &1))
    |> Enum.reduce(1, &*/2)
  end

  def count_trees(%CycledGrid{} = grid, slope) do
    count_trees(grid, slope, {0, 0})
  end

  defp count_trees(%CycledGrid{} = grid, slope, coord) do
    case CycledGrid.at(grid, coord) do
      :invalid_coord -> 0
      :tree -> 1 + count_trees(grid, slope, Vec2D.add(slope, coord))
      :empty -> 0 + count_trees(grid, slope, Vec2D.add(slope, coord))
    end
  end
end
