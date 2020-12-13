defmodule Advent2020.Days.Day13Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day13

  describe "find_earliest_bus/2" do
    test "sample input" do
      assert find_earliest_bus(939, [7, 13, 59, 31, 19]) == {59, 944}
    end

    test "real input" do
      assert part_one() == 2545
    end
  end

  describe "win_contest/1" do
    test "sample inputs" do
      assert win_contest([17,"x",13,19]) == 3417
      assert win_contest([7,13,"x","x",59,"x",31,19]) == 1068781
      assert win_contest([67,7,59,61]) == 754018
      assert win_contest([67,"x",7,59,61]) == 779210
      assert win_contest([67,7,"x",59,61]) == 1261476
      assert win_contest([1789,37,47,1889]) == 1202161486
    end

    test "real input" do
      assert part_two() == 266204454441577
    end
  end
end
