defmodule Advent2020.Days.Day19Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day19

  @sample """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
  """

  describe "parse/1" do
    test "can parse sample input" do
      {rules, messages} = parse(@sample)
      assert rules == [
        {0, [[4, 1, 5]]},
        {1, [[2, 3], [3, 2]]},
        {2, [[4, 4], [5, 5]]},
        {3, [[4, 5], [5, 4]]},
        {4, "a"},
        {5, "b"}
      ]

      assert messages == [
        "ababbb",
        "bababa",
        "abbbab",
        "aaabbb",
        "aaaabbb"
      ]
    end
  end

  describe "resolve_rule/3" do
    test "sample" do
      {rules, _messages} = parse(@sample)
      rules = Enum.into(rules, %{})
      assert resolve_rule(5, rules) == ["b"]
      assert resolve_rule(4, rules) == ["a"]
      assert resolve_rule(3, rules) == ["ab", "ba"]
      assert resolve_rule(2, rules) == ["aa", "bb"]
      assert resolve_rule(1, rules) == ["aaab", "aaba", "bbab", "bbba", "abaa", "abbb", "baaa", "babb"]
      assert resolve_rule(0, rules) == ["aaaabb", "aaabab", "abbabb", "abbbab", "aabaab", "aabbbb", "abaaab", "ababbb"]
    end
  end

  describe "find_matches/3" do
    test "sample" do
      {rules, messages} = parse(@sample)
      rules = Enum.into(rules, %{})
      assert find_matches(messages, rules, 0) == ["ababbb", "abbbab"]
    end

    test "real input" do
      assert part_one() == 220
    end
  end
end
