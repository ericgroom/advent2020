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
    |> perform_musical_chairs(&adjacent_neighbors/2, 4)
    |> count_occupied()
  end

  def part_two do
    @input
    |> parse()
    |> perform_musical_chairs(&visible_neighbors/2, 5)
    |> count_occupied()
  end

  def count_occupied(grid) do
    grid.data
    |> Map.values()
    |> Enum.count(fn cell -> cell == :occupied_seat end)
  end

  def perform_musical_chairs(%Grid{} = grid, neighbors, cramped_count) do
    Stream.iterate(grid, fn prev_grid -> perform_cycle(prev_grid, neighbors, cramped_count) end)
    |> Enum.reduce_while(nil, fn current, previous ->
      if not is_nil(previous) and Grid.equals?(current, previous) do
        {:halt, current}
      else
        {:cont, current}
      end
    end)
  end

  def perform_cycle(%Grid{} = grid, neighbors, cramped_count) do
    Grid.coords(grid)
    |> Enum.into(%{}, &transform(grid, &1, neighbors, cramped_count))
    |> Grid.new()
  end

  def transform(grid, point, neighbors, cramped_count) do
    current = Grid.at(grid, point)
    neighbors = neighbors.(grid, point)
    occupied_seats = Map.get(neighbors, :occupied_seat, 0)

    case {current, occupied_seats} do
      {:empty_seat, 0} ->
        {point, :occupied_seat}
      {:occupied_seat, count} when count >= cramped_count ->
        {point, :empty_seat}
      _ ->
        {point, current}
    end
  end

  def visible_neighbors(grid, point) do
    Vec2D.diagonal_unit_vectors()
    |> Enum.map(fn direction ->
      find_first_visible_seat(grid, point, direction)
    end)
    |> Enum.frequencies()
  end

  defp find_first_visible_seat(grid, point, direction) do
    next_point = Vec2D.add(point, direction)
    next = Grid.at(grid, next_point)

    case next do
      :floor ->
        find_first_visible_seat(grid, next_point, direction)

      _ ->
        next
    end
  end

  def adjacent_neighbors(%Grid{} = grid, point) do
    Vec2D.diagonal_unit_vectors()
    |> Enum.map(fn unit -> Vec2D.add(point, unit) end)
    |> Enum.map(fn point -> Grid.at(grid, point) end)
    |> Enum.frequencies()
  end
end
