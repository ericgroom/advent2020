defmodule Advent2020.Days.Day9 do
  use Advent2020.Day, day: 9

  import Advent2020.Math.TwoSum

  def part_one do
    @input
    |> Parser.parse_intlist()
    |> find_xmas_weakness(25)
  end

  def find_xmas_weakness(cipher, preamble_size) do
    {preamble, cipher} = Enum.split(cipher, preamble_size)

    traverse(cipher, preamble)
  end

  defp traverse([h | t] = _cipher, preamble) do
    if two_sum?(preamble, h) do
      new_preamble = push(preamble, h)
      traverse(t, new_preamble)
    else
      h
    end
  end

  defp push([], elem), do: [elem]

  defp push([_ | t], elem) do
    # head of preamble is the oldest
    t ++ [elem]
  end
end
