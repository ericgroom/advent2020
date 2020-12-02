defmodule Advent2020.Days.Day2 do
  use Advent2020.Day, day: 2, input: "day_2_input.txt"

  def part_one do
    @input
    |> parse_passwords()
    |> Enum.count(fn {password, policy} -> valid_password?(password, policy) end)
  end
  def part_two, do: nil

  def valid_password?(password, policy) do
    letter_frequencies = count_letters(password)
    actual_count = Map.get(letter_frequencies, policy.letter, 0)
    policy.min <= actual_count and actual_count <= policy.max
  end

  defp count_letters(word) do
    word
    |> String.graphemes()
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.update(acc, letter, 1, fn count -> count + 1 end)
    end)
  end

  alias __MODULE__.PasswordPolicy
  defmodule __MODULE__.PasswordPolicy do
    defstruct [:min, :max, :letter]
  end

  defp parse_passwords raw do
    raw
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_password/1)
  end

  defp parse_password password do
    trimmed = String.trim(password)
    [policy, password] = String.split(trimmed, ":") |> Enum.map(&String.trim/1)
    policy = parse_policy(policy)
    {password, policy}
  end

  defp parse_policy policy do
    [range, letter] = String.split(policy, " ")
    [min, max] = String.split(range, "-") |> Enum.map(&String.to_integer/1)
    %PasswordPolicy{min: min, max: max, letter: letter}
  end
end
