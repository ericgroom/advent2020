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
end
