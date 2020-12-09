defmodule Advent2020.Days.Day9 do
  use Advent2020.Day, day: 9

  import Advent2020.Math.TwoSum
  import Inline

  def part_one do
    @input
    |> Parser.parse_intlist()
    |> find_xmas_weakness(25)
  end

  def part_two do
    @input
    |> Parser.parse_intlist()
    |> find_summed_weakness(25)
  end

  def find_summed_weakness(cipher, preamble_size) do
    target = find_xmas_weakness(cipher, preamble_size)
    sequence = find_contiguous_sum(cipher, target)
    max = Enum.max(sequence)
    min = Enum.min(sequence)
    max + min
  end

  def find_contiguous_sum([_ | t] = cipher, target) do
    case try_subsequence(cipher, target) do
      {:found, sequence} when length(sequence) >= 2 ->
        sequence

      _ ->
        find_contiguous_sum(t, target)
    end
  end

  test try_subsequence([1, 2], 3), is: {:found, [2, 1]}
  test try_subsequence([1, 2], 4), is: :ran_out
  test try_subsequence([5, 2], 4), is: :exceeded
  defp try_subsequence(cipher, target, sequence \\ [])

  defp try_subsequence([], target, sequence) do
    if Enum.sum(sequence) == target do
      {:found, sequence}
    else
      :ran_out
    end
  end

  defp try_subsequence([h | t], target, sequence) do
    sum = Enum.sum(sequence)

    cond do
      sum == target ->
        {:found, sequence}

      sum > target ->
        :exceeded

      true ->
        try_subsequence(t, target, [h | sequence])
    end
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
