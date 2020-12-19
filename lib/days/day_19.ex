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
      # join all possibilities within a branch
      # 0: 4 1 5
      # 1: 2 3 | 3 2
      # 2: 4 4 | 5 5
      # 3: 4 5 | 5 4
      # 4: "a"
      # 5: "b"

      # 1: two and three has multiple possible subrules, we have to combine cartesian product I think
      # 3: 4 resolves to ["a"] 5 resolves to ["b"]
      # 3: has 2 branches
      # 3: 4 5 means the below map will result in [["a"], ["b"]], to get the correct answer we just join them
      # 3: 5 4 means the below map will result in [["b"], ["a"]], "
      # 3: join the two branches and we get ["ab", "ba"]
      # 2: resolves to ["aa", "bb"]
      # 1: first branch we get [["aa", "bb"], ["ab", "ba"]]
      # 1: second branch we get [["ab", "ba"], ["aa", "bb"]]
      # 1: to combine the first branch, we do "aa" <> "ab", "aa" <> "ba", "bb" <> "ab", "bb" <> "ba" ["aaab", "aaba", "bbab", "bbba"]
      # 1: to combine the second branch, we do "ab" <> "aa", "ab" <> "bb", "ba" <> "aa", "ba" <> "bb" ["abaa", "abbb", "baaa", "babb"]
      # 1: to combine the branches, just join the lists into one list
      # to combine within a branch, do cartesian product

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
