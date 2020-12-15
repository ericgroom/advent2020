defmodule Advent2020.Days.Day15Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day15

  describe "play_memory_game/1" do
    test "sample inputs" do
      assert play_memory_game([0, 3, 6], 2020) == 436
      assert play_memory_game([1, 3, 2], 2020) == 1
      assert play_memory_game([2, 1, 3], 2020) == 10
      assert play_memory_game([1, 2, 3], 2020) == 27
      assert play_memory_game([2, 3, 1], 2020) == 78
      assert play_memory_game([3, 2, 1], 2020) == 438
      assert play_memory_game([3, 1, 2], 2020) == 1836
    end

    test "real input" do
      assert part_one() == 929
    end

    test "part two" do
      assert part_two() == 16671510
    end
  end
end
