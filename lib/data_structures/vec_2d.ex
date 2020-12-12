defmodule Advent2020.DataStructures.Vec2D do
  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def diagonal_unit_vectors() do
    [{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}]
  end

  def nondiagonal_unit_vectors() do
    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
  end
end
