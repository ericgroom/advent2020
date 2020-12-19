defmodule Advent2020.Days.Day19 do
  use Advent2020.Day, day: 19

  def parse(raw) do
    [rules, messages] = String.split(raw, "\n\n", trim: true)

    rules = rules
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)

    messages = String.split(messages, "\n", trim: true)

    {rules, messages}
  end

  defp parse_rule(rule) do
    [num, predicate] = String.split(rule, ": ", trim: true)
    predicate = if String.starts_with?(predicate, "\"") do
      parse_predicate(predicate)
    else
      parse_nested_predicate(predicate)
    end
    {String.to_integer(num), predicate}
  end

  defp parse_predicate(raw) do
    ["\"", letter, "\""] = String.graphemes(raw)
    letter
  end

  defp parse_nested_predicate(raw) do
    raw
    |> String.split(" | ", trim: true)
    |> Enum.map(fn intlist ->
      for i <- String.split(intlist), do: String.to_integer(i)
    end)
  end
end
