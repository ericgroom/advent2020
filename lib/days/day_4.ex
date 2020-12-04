defmodule Advent2020.Days.Day4 do
  use Advent2020.Day, day: 4

  def part_one do
    @input
    |> parse()
    |> Stream.map(&valid_north_pole_credentials?/1)
    |> Stream.filter(& &1)
    |> Enum.count()
  end

  def part_two do
    @input
    |> parse()
    |> Stream.map(fn passport ->
      valid_north_pole_credentials?(passport) && valid_values?(passport)
    end)
    |> Stream.filter(& &1)
    |> Enum.count()
  end

  defp parse(raw) do
    raw
    |> String.split("\n\n")
    |> Stream.map(fn passport -> String.replace(passport, "\n", " ") end)
    |> Stream.map(&parse_passport/1)
  end

  defp parse_passport(passport) do
    passport
    |> String.split(" ")
    |> Stream.filter(&("" != &1))
    |> Stream.map(fn field ->
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

  def valid_values?(passport) do
    @north_pole_fields
    |> Enum.map(fn key -> {key, Map.fetch!(passport, key)} end)
    |> Enum.all?(fn {key, value} -> valid_key_value?(key, value) end)
  end

  def valid_key_value?("byr", year) do
    int_year = String.to_integer(year)
    String.length(year) == 4 and 1920 <= int_year and int_year <= 2002
  end

  def valid_key_value?("iyr", year) do
    int_year = String.to_integer(year)
    String.length(year) == 4 and 2010 <= int_year and int_year <= 2020
  end

  def valid_key_value?("eyr", year) do
    int_year = String.to_integer(year)
    String.length(year) == 4 and 2020 <= int_year and int_year <= 2030
  end

  def valid_key_value?("hgt", height) do
    {int, unit} = Integer.parse(height)

    case unit do
      "cm" -> 150 <= int and int <= 193
      "in" -> 59 <= int and int <= 76
      _ -> false
    end
  end

  def valid_key_value?("hcl", color) do
    String.length(color) == 7 && String.starts_with?(color, "#") &&
      match?({_int, ""}, Integer.parse(String.slice(color, 1..String.length(color)), 16))
  end

  def valid_key_value?("ecl", color) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], color)
  end

  def valid_key_value?("pid", pid) do
    String.length(pid) == 9 and match?({_int, ""}, Integer.parse(pid, 10))
  end

  def valid_key_value?("cid", _cid), do: true
end
