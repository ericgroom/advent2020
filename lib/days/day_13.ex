defmodule Advent2020.Days.Day13 do
  use Advent2020.Day, day: 13

  def part_one do
    {earliest, buses} = parse(@input)
    without_xs = Enum.filter(buses, &is_integer/1)
    {bus_id, departs} = find_earliest_bus(earliest, without_xs)
    wait_time = departs - earliest
    bus_id * wait_time
  end

  def part_two do
    {_earliest, buses} = parse(@input)
    win_contest(buses)
  end

  def win_contest(buses) do
    with_rem = buses
    |> Stream.with_index()
    |> Stream.filter(fn {v, _i} -> v != "x" end)
    |> invert_rem()

    big_n = calc_N(with_rem)

    unreduced_solution = with_rem
    |> Enum.map(&calc_row_product(&1, big_n))
    |> Enum.sum()

    rem(unreduced_solution, big_n)
  end

  def calc_row_product({id, rem}, big_n) do
    n_i = div(big_n, id)
    # n_i*x_i cong. 1 (mod id)
    reduced_n_i = rem(n_i, id)
    x_i = inverse_mod(reduced_n_i, id)
    x_i * n_i * rem
  end

  def inverse_mod(a, m) do
    1..10_000
    |> Enum.find(fn x -> rem(a*x, m) == 1 end)
  end

  def invert_rem(buses) do
    buses
    |> Enum.map(fn {id, rem} -> {id, rem((id - rem), id)} end)
  end

  def calc_N(buses) do
    buses
    |> Enum.map(fn {id, _rem} -> id end)
    |> Enum.reduce(1, &*/2)
  end

  def parse(raw) do
    [earliest, buses] = String.split(raw, "\n", trim: true)
    earliest = String.to_integer(earliest)
    buses = buses
        |> String.split(",")
        |> Enum.map(fn
            "x" -> "x"
             n -> String.to_integer(n)
        end)
    {earliest, buses}
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
