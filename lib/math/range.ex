defmodule Advent2020.Math.Range do
  def upper_half(range) do
    %{first: first, last: inclusive_last} = Map.from_struct(range)
    last = inclusive_last + 1
    mid = div(first + last, 2)
    mid..inclusive_last
  end

  def lower_half(range) do
    %{first: first, last: inclusive_last} = Map.from_struct(range)
    last = inclusive_last + 1
    mid = div(first + last, 2)
    first..(mid - 1)
  end

  def single_elem(range) do
    %{first: first, last: last} = Map.from_struct(range)
    if first == last, do: first, else: nil
  end
end
