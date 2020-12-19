defmodule Advent2020.Days.Day19 do
  use Advent2020.Day, day: 19

  def part_one do
    {rules, messages} = parse(@input)
    find_matches(messages, rules, 0)
    |> Enum.count()
  end

  def part_two do
    {rules, messages} = parse(@input)
    find_matches_pt2(messages, rules)
    |> Enum.count()
  end

  def find_matches_pt2(messages, rules) do
    # 0: 8 11
    # 8: 42 | 42 8
    # 11: 42 31 | 42 11 31
    # 8 essentially means 42 as many times as you want
    # 11 essentially means nest 42 31 into itself as many as you want
    # NOTHING USES 8 and 11 but 0
    # iterate until 42 no longer matches
    # make sure the rest are 31 and that there are as least as many 42s as 31s
    forty_two_patterns = resolve_rule(42, rules) |> MapSet.new()
    thirty_one_patterns = resolve_rule(31, rules) |> MapSet.new()
    chunk_size = thirty_one_patterns |> Enum.take(1) |> List.first() |> String.length()

    messages
    |> Enum.filter(fn message ->
      chunks = message
        |> String.graphemes()
        |> Enum.chunk_every(chunk_size)
        |> Enum.map(fn letters ->
          Enum.join(letters)
        end)

      {forty_two_matches, rest} = chunks
        |> Enum.split_while(&MapSet.member?(forty_two_patterns, &1))

      {thirty_one_matches, rest} = rest
        |> Enum.split_while(&MapSet.member?(thirty_one_patterns, &1))

      forty_two_matches_count = Enum.count(forty_two_matches)
      thirty_one_matches_count = Enum.count(thirty_one_matches)
      ratio_is_good = (forty_two_matches_count - 1) >= thirty_one_matches_count # asserts that there is at least one more 42 than there is 31

      thirty_one_matches_count > 0 and ratio_is_good and rest == []
    end)
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
      |> Enum.into(%{}, &parse_rule/1)

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
