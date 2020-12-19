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
      assert rules == %{
        0 => [[4, 1, 5]],
        1 => [[2, 3], [3, 2]],
        2 => [[4, 4], [5, 5]],
        3 => [[4, 5], [5, 4]],
        4 => "a",
        5 => "b"
      }

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
      assert find_matches(messages, rules, 0) == ["ababbb", "abbbab"]
    end

    @tag :slow
    test "real input" do
      assert part_one() == 220
    end
  end

  @sample_pt2 """
  42: 9 14 | 10 1
  9: 14 27 | 1 26
  10: 23 14 | 28 1
  1: "a"
  11: 42 31
  5: 1 14 | 15 1
  19: 14 1 | 14 14
  12: 24 14 | 19 1
  16: 15 1 | 14 14
  31: 14 17 | 1 13
  6: 14 14 | 1 14
  2: 1 24 | 14 4
  0: 8 11
  13: 14 3 | 1 12
  15: 1 | 14
  17: 14 2 | 1 7
  23: 25 1 | 22 14
  28: 16 1
  4: 1 1
  20: 14 14 | 1 15
  3: 5 14 | 16 1
  27: 1 6 | 14 18
  14: "b"
  21: 14 1 | 1 14
  25: 1 1 | 1 14
  22: 14 14
  8: 42
  26: 14 22 | 1 20
  18: 15 15
  7: 14 5 | 1 21
  24: 14 1

  abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
  bbabbbbaabaabba
  babbbbaabbbbbabbbbbbaabaaabaaa
  aaabbbbbbaaaabaababaabababbabaaabbababababaaa
  bbbbbbbaaaabbbbaaabbabaaa
  bbbababbbbaaaaaaaabbababaaababaabab
  ababaaaaaabaaab
  ababaaaaabbbaba
  baabbaaaabbaaaababbaababb
  abbbbabbbbaaaababbbbbbaaaababb
  aaaaabbaabaaaaababaa
  aaaabbaaaabbaaa
  aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
  babaaabbbaaabaababbaabababaaab
  aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
  """

  describe "find_matches_pt2/2" do
    test "sample" do
      {rules, messages} = parse(@sample_pt2)
      assert find_matches_pt2(messages, rules) == [
          "bbabbbbaabaabba",
          "babbbbaabbbbbabbbbbbaabaaabaaa",
          "aaabbbbbbaaaabaababaabababbabaaabbababababaaa",
          "bbbbbbbaaaabbbbaaabbabaaa",
          "bbbababbbbaaaaaaaabbababaaababaabab",
          "ababaaaaaabaaab",
          "ababaaaaabbbaba",
          "baabbaaaabbaaaababbaababb",
          "abbbbabbbbaaaababbbbbbaaaababb",
          "aaaaabbaabaaaaababaa",
          "aaaabbaabbaaaaaaabbbabbbaaabbaabaaa",
          "aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"
      ]
    end

    test "real input" do
      assert part_two() == 439
    end
  end
end
