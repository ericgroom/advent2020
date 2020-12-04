defmodule Advent2020.Days.Day2 do
  use Advent2020.Day, day: 2

  def part_one do
    count_valid_passwords(&valid_password?/2)
  end

  def part_two do
    count_valid_passwords(&valid_official_password?/2)
  end

  defp count_valid_passwords(validator) when is_function(validator, 2) do
    @input
    |> parse_passwords()
    |> Enum.count(fn {password, policy} -> validator.(password, policy) end)
  end

  alias __MODULE__.PasswordPolicy

  defmodule __MODULE__.PasswordPolicy do
    defstruct [:num_one, :num_two, :letter]
  end

  def valid_official_password?(password, %PasswordPolicy{
        num_one: pos_one,
        num_two: pos_two,
        letter: letter
      }) do
    letter_one = String.at(password, pos_one - 1)
    letter_two = String.at(password, pos_two - 1)

    (letter_one == letter and letter_two != letter) or
      (letter_two == letter and letter_one != letter)
  end

  def valid_password?(password, %PasswordPolicy{num_one: min, num_two: max, letter: letter}) do
    letter_frequencies = count_letters(password)
    actual_count = Map.get(letter_frequencies, letter, 0)
    min <= actual_count and actual_count <= max
  end

  defp count_letters(word) do
    word
    |> String.graphemes()
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.update(acc, letter, 1, fn count -> count + 1 end)
    end)
  end

  defp parse_passwords(raw) do
    raw
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_password/1)
  end

  defp parse_password(password) do
    trimmed = String.trim(password)
    [policy, password] = String.split(trimmed, ":") |> Enum.map(&String.trim/1)
    policy = parse_policy(policy)
    {password, policy}
  end

  defp parse_policy(policy) do
    [range, letter] = String.split(policy, " ")
    [min, max] = String.split(range, "-") |> Enum.map(&String.to_integer/1)
    %PasswordPolicy{num_one: min, num_two: max, letter: letter}
  end
end
