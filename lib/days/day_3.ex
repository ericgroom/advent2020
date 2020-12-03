defmodule Advent2020.Days.Day3 do
  use Advent2020.Day, day: 3, input: "day_3_input.txt"

  alias Advent2020.DataStructures.{CycledGrid, Coord2D}

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
    |> Enum.reduce(1, fn x, acc -> acc * x end)
  end

  def count_trees(%CycledGrid{} = grid, {_x_inc, _y_inc} = slope) do
    count_trees(grid, slope, %Coord2D{x: 0, y: 0})
  end

  defp count_trees(%CycledGrid{} = grid, {x_inc, y_inc}, %Coord2D{} = coord) do
    if !CycledGrid.exists?(grid, coord) do
      0
    else
      count =
        case CycledGrid.at(grid, coord) do
          :tree -> 1
          :empty -> 0
        end

      count + count_trees(grid, {x_inc, y_inc}, %Coord2D{x: coord.x + x_inc, y: coord.y + y_inc})
    end
  end
end
