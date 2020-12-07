defmodule Advent2020.Days.Day5 do
  use Advent2020.Day, day: 5
  import Inline

  alias Advent2020.Math.Range, as: R

  @plane_area {0..127, 0..7}

  def part_one do
    scanned_seats()
    |> Stream.map(&seat_id/1)
    |> Enum.max()
  end

  def part_two do
    scanned_seats()
    |> Enum.into(MapSet.new())
    |> find_my_seat(all_seats(@plane_area))
    |> seat_id()
  end

  def scanned_seats do
    @input
    |> String.split()
    |> Stream.map(&seat_number(&1, @plane_area))
  end

  def all_seats({vertical, horizontal}) do
    Stream.flat_map(vertical, fn row ->
      Stream.map(horizontal, fn col -> {row, col} end)
    end)
    |> Enum.into(MapSet.new())
  end

  def find_my_seat(scanned_seats, all_seats) do
    missing_seats = MapSet.difference(all_seats, scanned_seats)

    Enum.find(missing_seats, fn {row, _} ->
      count_in_row = Enum.count(missing_seats, fn {row_i, _} -> row_i == row end)
      count_in_row == 1
    end)
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

  test reduce_space("F", {0..63, 0..7}), is: {0..31, 0..7}

  defp reduce_space("F", {vertical_range, horizontal_range}) do
    {R.lower_half(vertical_range), horizontal_range}
  end

  test reduce_space("B", {0..63, 0..7}), is: {32..63, 0..7}

  defp reduce_space("B", {vertical_range, horizontal_range}) do
    {R.upper_half(vertical_range), horizontal_range}
  end

  test reduce_space("L", {0..63, 0..7}), is: {0..63, 0..3}

  defp reduce_space("L", {vertical_range, horizontal_range}) do
    {vertical_range, R.lower_half(horizontal_range)}
  end

  test reduce_space("R", {0..63, 0..7}), is: {0..63, 4..7}

  defp reduce_space("R", {vertical_range, horizontal_range}) do
    {vertical_range, R.upper_half(horizontal_range)}
  end
end
