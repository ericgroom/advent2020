defmodule Advent2020.Days.Day4 do
  use Advent2020.Day, day: 4, input: "day_4_input.txt"

  def part_one do
    @input
    |> parse()
    |> Enum.map(&valid_north_pole_credentials?/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  defp parse(raw) do
    raw
    |> String.split("\n\n")
    |> Enum.map(fn passport -> String.replace(passport, "\n", " ") end)
    |> Enum.map(&parse_passport/1)
  end

  defp parse_passport(passport) do
    passport
    |> String.split(" ")
    |> Enum.filter(&("" != &1))
    |> Enum.map(fn field ->
      [key, value] = field |> String.trim() |> String.split(":")
      {key, value}
    end)
    |> Enum.into(%{})
  end

  @passport_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
  @north_pole_fields List.delete(@passport_fields, "cid")

  def valid_north_pole_credentials?(passport) do
    @north_pole_fields
    |> Enum.map(&Map.fetch(passport, &1))
    |> Enum.all?(fn field -> match?({:ok, _value}, field) end)
  end
end
