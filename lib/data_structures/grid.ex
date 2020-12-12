defmodule Advent2020.DataStructures.Grid do
  defstruct [:data, :rows, :cols]

  alias Advent2020.DataStructures.Vec2D
  alias __MODULE__

  def new() do
    %Grid{data: %{}, rows: 0, cols: 0}
  end

  def new(nested_list) do
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

  def put(%Grid{data: data} = grid, %Vec2D{} = coord, value) do
    rows = max(grid.rows, coord.y + 1)
    cols = max(grid.cols, coord.x + 1)
    new_grid = Map.put(data, coord, value)
    %Grid{data: new_grid, rows: rows, cols: cols}
  end

  def coords(%Grid{data: data}) do
    data |> Map.keys()
  end

  def nested_coords(%Grid{rows: rows, cols: cols}) do
    0..(rows - 1)
    |> Stream.map(fn row_i ->
      Stream.map(0..(cols - 1), fn col_i ->
        Vec2D.new({col_i, row_i})
      end)
    end)
  end
end
