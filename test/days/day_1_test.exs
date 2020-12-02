defmodule Advent2020.Days.Day1Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day1

  describe "find_expense_anomoly" do
    test "sample input" do
      input = [1721, 979, 366, 299, 675, 1456]
      output = find_expense_anomoly(input)
      assert output == 514_579
    end

    test "real input" do
      assert part_one() == 876_459
    end
  end

  describe "find_other_anomoly" do
    test "sample input" do
      input = [1721, 979, 366, 299, 675, 1456]
      output = find_other_anomoly(input)
      assert output == 241_861_950
    end

    test "real input" do
      assert part_two() == 116_168_640
    end
  end
end
