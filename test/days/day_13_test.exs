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
end
