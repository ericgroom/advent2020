defmodule Advent2020.Days.Day5 do
  use Advent2020.Day, day: 5

  alias Advent2020.Math.Range, as: R

  @plane_area {0..127, 0..7}

  def part_one do
    @input
    |> String.split()
    |> Stream.map(&seat_number(&1, @plane_area))
    |> Stream.map(&seat_id/1)
    |> Enum.max()
  end

  def seat_id({row, col}), do: row * 8 + col

  def seat_number(space_partition, range_spaces) when is_binary(space_partition) do
    seat_number(space_partition |> String.graphemes(), range_spaces)
  end

  def seat_number([h | t] = space_partition, range_spaces) when is_list(space_partition) do
    {vertical, horizontal} = reduce_space(h, range_spaces)

    if t == [] do
      {R.single_elem(vertical), R.single_elem(horizontal)}
    else
      seat_number(t, {vertical, horizontal})
    end
  end

  defp reduce_space("F", {vertical_range, horizontal_range}) do
    {R.lower_half(vertical_range), horizontal_range}
  end

  defp reduce_space("B", {vertical_range, horizontal_range}) do
    {R.upper_half(vertical_range), horizontal_range}
  end

  defp reduce_space("L", {vertical_range, horizontal_range}) do
    {vertical_range, R.lower_half(horizontal_range)}
  end

  defp reduce_space("R", {vertical_range, horizontal_range}) do
    {vertical_range, R.upper_half(horizontal_range)}
  end
end
