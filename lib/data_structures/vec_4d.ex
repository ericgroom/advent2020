defmodule Advent2020.DataStructures.Vec4D do
  def add({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: {x1 + x2, y1 + y2, z1 + z2, w1 + w2}

  @units for x <- -1..1,
             y <- -1..1,
             z <- -1..1,
             w <- -1..1,
             x != 0 or y != 0 or z != 0 or w != 0,
             do: {x, y, z, w}

  def unit_vectors() do
    # 80
    @units
  end
end
