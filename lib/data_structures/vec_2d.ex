defmodule Advent2020.DataStructures.Vec2D do
  defstruct [:x, :y]

  def add(%__MODULE__{x: x1, y: y1}, %__MODULE__{x: x2, y: y2}),
    do: %__MODULE__{x: x1 + x2, y: y1 + y2}

  def new({x, y}), do: %__MODULE__{x: x, y: y}

  def unit_vectors(opts \\ [diagonal: false]) do
    include_diagonal = Keyword.get(opts, :diagonal, false)

    if include_diagonal do
      nondiagonal_unit_vectors() ++ diagonal_unit_vectors()
    else
      nondiagonal_unit_vectors()
    end
  end

  defp diagonal_unit_vectors() do
    [{1, -1}, {1, 1}, {-1, 1}, {-1, -1}]
    |> Enum.map(&__MODULE__.new/1)
  end

  defp nondiagonal_unit_vectors() do
    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
    |> Enum.map(&__MODULE__.new/1)
  end
end
