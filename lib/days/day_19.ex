defmodule Advent2020.Days.Day19 do
  use Advent2020.Day, day: 19

  def part_one do
    {rules, messages} = parse(@input)
    rules = Enum.into(rules, %{})
    find_matches(messages, rules, 0)
    |> Enum.count()
  end

  def find_matches(messages, rules, rule_no) do
    patterns = resolve_rule(rule_no, rules) |> MapSet.new()

    messages
    |> Enum.filter(&MapSet.member?(patterns, &1))
  end

  def resolve_rule(rule_no, rule_map) do
    case Map.get(rule_map, rule_no) do
      letter when is_binary(letter) -> [letter]
      nested_rules when is_list(nested_rules) ->
        nested_rules
        |> Enum.flat_map(fn branch ->
          Enum.map(branch, fn rule_no -> resolve_rule(rule_no, rule_map) end)
          |> concat_product()
        end)
    end
  end

  defp concat_product([as]), do: as
  defp concat_product([as, bs]) do
    for a <- as, b <- bs, do: a <> b
  end
  defp concat_product([as, bs, cs]) do
    for a <- as, b <- bs, c <- cs, do: a <> b <> c
  end

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
