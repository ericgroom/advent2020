defmodule Advent2020.Days.Day10 do
  use Advent2020.Day, day: 10

  def part_one do
    differentials =
      @input
      |> Parser.parse_intlist()
      |> count_differentials()

    differentials[1] * differentials[3]
  end

  def count_differentials(adapters) do
    adapters
    |> create_adapter_chain()
    |> joltage_differentials()
    |> Enum.group_by(& &1)
    |> Enum.into(%{}, fn {x, xs} -> {x, Enum.count(xs)} end)
  end

  def joltage_differentials(chain) do
    pairwise = Stream.zip(chain, tl(chain))

    pairwise
    |> Enum.map(fn {previous, next} -> next - previous end)
  end

  def create_adapter_chain(adapters) do
    outlet_joltage = 0
    device_joltage = Enum.max(adapters) + 3
    [outlet_joltage | Enum.sort(adapters)] ++ [device_joltage]
  end
end
