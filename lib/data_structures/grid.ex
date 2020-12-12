defmodule Advent2020.DataStructures.Grid do
  defstruct [:data, :rows, :cols]

  alias Advent2020.DataStructures.Vec2D
  alias __MODULE__

  def new() do
    %Grid{data: %{}}
  end

  def new(coord_map) when is_map(coord_map) do
    %Grid{data: coord_map}
  end

  def new(nested_list) when is_list(nested_list) do
    rows = Enum.count(nested_list)
    cols = Enum.at(nested_list, 0, []) |> Enum.count()

    data =
      nested_list
      |> Stream.with_index()
      |> Enum.flat_map(fn {row, row_i} ->
        row
        |> Stream.with_index()
        |> Stream.map(fn {cell, col_i} ->
          {Vec2D.new({col_i, row_i}), cell}
        end)
      end)
      |> Enum.into(%{})

    %Grid{data: data, rows: rows, cols: cols}
  end

  def at(%Grid{} = grid, %Vec2D{} = coord) do
    Map.get(grid.data, coord, :invalid_coord)
  end

  def equals?(%Grid{data: data_one}, %Grid{data: data_two}) do
    Map.equal?(data_one, data_two)
  end

  def put(%Grid{data: data}, %Vec2D{} = coord, value) do
    new_grid = Map.put(data, coord, value)
    %Grid{data: new_grid}
  end

  def coords(%Grid{data: data}) do
    data |> Map.keys()
  end
end
