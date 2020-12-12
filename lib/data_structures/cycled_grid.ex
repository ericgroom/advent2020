defmodule Advent2020.DataStructures.CycledGrid do
  alias __MODULE__
  alias Advent2020.DataStructures.Vec2D

  defstruct [:data, :row_length]

  def new(nested_list) do
    row_length = nested_list |> Enum.at(0) |> Enum.count()
    data = nested_list |> List.flatten()
    %CycledGrid{data: data, row_length: row_length}
  end

  def at(%CycledGrid{} = grid, coord) do
    translated = translate_coord(grid, coord)
    i = to_index(grid, translated)

    if i >= 0 and i < Enum.count(grid.data) do
      Enum.at(grid.data, i)
    else
      :invalid_coord
    end
  end

  alias __MODULE__.UncycledCoord

  defmodule __MODULE__.UncycledCoord do
    defstruct [:x, :y]
  end

  defp translate_coord(%CycledGrid{row_length: row_length}, {x,  y}) do
    x = rem(x, row_length)
    %UncycledCoord{x: x, y: y}
  end

  defp to_index(%CycledGrid{row_length: row_length}, %UncycledCoord{x: x, y: y}) do
    y * row_length + x
  end
end
