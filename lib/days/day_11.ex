defmodule Advent2020.Days.Day11 do
  use Advent2020.Day, day: 11

  alias Advent2020.DataStructures.{Grid, Vec2D}

  def parse(raw) do
    raw
    |> Parser.parse_grid(fn
      "L" -> :empty_seat
      "." -> :floor
      "#" -> :occupied_seat
    end)
    |> Grid.new()
  end

  def part_one do
    @input
    |> parse()
    |> perform_musical_chairs(&transform_adjacent/2)
    |> count_occupied()
  end

  def count_occupied(grid) do
    grid.data
    |> Map.values()
    |> Enum.count(fn cell -> cell == :occupied_seat end)
  end

  def perform_musical_chairs(%Grid{} = grid, transform) do
    Stream.iterate(grid, fn prev_grid -> perform_cycle(prev_grid, transform) end)
    |> Enum.reduce_while(nil, fn current, previous ->

      if not is_nil(previous) and Grid.equals?(current, previous) do
        {:halt, current}
      else
        {:cont, current}
      end
    end)
  end

  def to_s(grid) do
    Grid.nested_coords(grid)
    |> Enum.map(fn row ->
      Enum.map(row, fn point ->
        case Grid.at(grid, point) do
          :empty_seat ->
            "L"

          :occupied_seat ->
            "#"

          :floor ->
            "."
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def perform_cycle(%Grid{} = grid, transform) do
    Grid.coords(grid)
    |> Enum.map(fn point ->
      transform.(grid, point)
    end)
    |> Enum.reduce(Grid.new(), fn {coord, value}, acc ->
      Grid.put(acc, coord, value)
    end)
  end

  def transform_adjacent(grid, point) do
      current = Grid.at(grid, point)
      neighbors = neighbors(grid, point)

      cond do
          current == :empty_seat and Map.get(neighbors, :occupied_seat, 0) == 0 ->
          {point, :occupied_seat}

          current == :occupied_seat and Map.get(neighbors, :occupied_seat, 0) >= 4 ->
          {point, :empty_seat}

          true ->
          {point, current}
      end
  end

  def neighbors(%Grid{} = grid, %Vec2D{} = point) do
    Vec2D.unit_vectors(diagonal: true)
    |> Enum.map(fn unit -> Vec2D.add(unit, point) end)
    |> Enum.map(fn point -> Grid.at(grid, point) end)
    |> Enum.frequencies()
  end
end
