defmodule Advent2020.Days.Day13 do
  use Advent2020.Day, day: 13

  def part_one do
    {earliest, busses} = parse(@input)
    without_xs = Enum.filter(busses, &is_integer/1)
    {bus_id, departs} = find_earliest_bus(earliest, without_xs)
    wait_time = departs - earliest
    bus_id * wait_time
  end

  def parse(raw) do
    [earliest, busses] = String.split(raw, "\n", trim: true)
    earliest = String.to_integer(earliest)
    busses = busses
        |> String.split(",")
        |> Enum.map(fn
            "x" -> "x"
             n -> String.to_integer(n)
        end)
    {earliest, busses}
  end

  def find_earliest_bus(after_time, bus_ids) do
    bus_ids
    |> Enum.map(fn bus_id ->
      {bus_id, find_nearest_departure(after_time, bus_id)}
    end)
    |> Enum.min_by(fn {_id, time} -> time end)
  end

  def find_nearest_departure(after_time, bus_id) do
    bus_id - rem(after_time, bus_id) + after_time
  end
end
