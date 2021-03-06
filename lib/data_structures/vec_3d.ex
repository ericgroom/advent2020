defmodule Advent2020.DataStructures.Vec3D do
  def partial(x, y), do: {x, y, 0}

  def add({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}

  def unit_vectors() do
    # 26
    [
      # z + 0, 8 total
      {1, 0, 0},
      {-1, 0, 0},
      {0, 1, 0},
      {0, -1, 0},
      {1, 1, 0},
      {1, -1, 0},
      {-1, 1, 0},
      {-1, -1, 0},
      # z + 1, 9 total
      {0, 0, 1},
      {1, 0, 1},
      {-1, 0, 1},
      {0, 1, 1},
      {0, -1, 1},
      {1, 1, 1},
      {1, -1, 1},
      {-1, 1, 1},
      {-1, -1, 1},
      # z - 1, 9 total
      {0, 0, -1},
      {1, 0, -1},
      {-1, 0, -1},
      {0, 1, -1},
      {0, -1, -1},
      {1, 1, -1},
      {1, -1, -1},
      {-1, 1, -1},
      {-1, -1, -1},
    ]
  end
end
