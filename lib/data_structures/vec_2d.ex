defmodule Advent2020.DataStructures.Vec2D do
  defstruct [:x, :y]

  def add(%__MODULE__{x: x1, y: y1}, %__MODULE__{x: x2, y: y2}),
    do: %__MODULE__{x: x1 + x2, y: y1 + y2}

  def new({x, y}), do: %__MODULE__{x: x, y: y}
end
