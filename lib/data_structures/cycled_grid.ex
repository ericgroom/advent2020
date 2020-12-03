defmodule Advent2020.DataStructures.CycledGrid do
  alias __MODULE__
  alias Advent2020.DataStructures.Coord2D

  defstruct [:data, :row_length]

  def new(nested_list) do
    row_length = nested_list |> Enum.at(0) |> Enum.count()
    data = nested_list |> List.flatten()
    %CycledGrid{data: data, row_length: row_length}
  end

  def at(%CycledGrid{} = grid, %Coord2D{} = coord) do
    translated = translate_coord(grid, coord)
    i = to_index(grid, translated)
    Enum.at(grid.data, i)
  end

  def exists?(%CycledGrid{data: data} = grid, %Coord2D{} = coord) do
    translated = translate_coord(grid, coord)
    i = to_index(grid, translated)

    i < Enum.count(data)
  end

  alias __MODULE__.UncycledCoord

  defmodule __MODULE__.UncycledCoord do
    defstruct [:x, :y]
  end

  defp translate_coord(%CycledGrid{row_length: row_length}, %Coord2D{x: x, y: y}) do
    x = rem(x, row_length)
    %UncycledCoord{x: x, y: y}
  end

  defp to_index(%CycledGrid{row_length: row_length}, %UncycledCoord{x: x, y: y}) do
    y * row_length + x
  end
end
