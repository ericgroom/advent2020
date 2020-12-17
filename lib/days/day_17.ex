defmodule Advent2020.Days.Day17 do
  use Advent2020.Day, day: 17

  alias Advent2020.DataStructures.Vec3D

  def part_one do
    @input
    |> parse(&Vec3D.partial/2)
    |> run_n_cycles(Vec3D, 6)
    |> count_active()
  end

  defp count_active(grid) do
    grid
    |> Map.values()
    |> Enum.count(& &1 == :active)
  end

  def run_n_cycles(grid, vec, n) do
    Stream.iterate(grid, &run_cycle(&1, vec))
    |> Enum.at(n)
  end

  def run_cycle(grid, vec) do
    with_immediate_neighbors = grid
      |> Map.keys()
      |> Enum.reduce(grid, fn coord, acc ->
        vec.unit_vectors()
        |> Enum.map(&vec.add(&1, coord))
        |> Enum.reduce(acc, &Map.put_new(&2, &1, :inactive))
      end)

    with_immediate_neighbors
    |> Map.keys()
    |> Enum.into(%{}, fn coord ->
      neighbor_coords = vec.unit_vectors() |> Enum.map(&vec.add(&1, coord))
      neighbors = Enum.map(neighbor_coords, fn coord -> {coord, Map.get(with_immediate_neighbors, coord, :inactive)} end)
      # TODO don't forget to add neighbors to grid
      {coord, determine_state(with_immediate_neighbors, coord, neighbors)}
    end)
  end

  defp determine_state(grid, at, neighbors) do
    current = Map.fetch!(grid, at)
    active_count = neighbors
      |> Enum.count(fn {_coord, val} -> val == :active end)

    cond do
      current == :active and (active_count == 2 or active_count == 3)  ->
        :active
      current == :inactive and active_count == 3 ->
        :active
      true ->
        :inactive
    end
  end

  def parse(raw, coord_factory) do
    Parser.parse_grid(raw, fn
      "." -> :inactive
      "#" -> :active
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {elem, x} ->
        {coord_factory.(x, y), elem}
      end)
    end)
    |> Enum.into(%{})
  end
end
