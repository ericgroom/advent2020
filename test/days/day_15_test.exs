defmodule Advent2020.Days.Day15Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day15

  describe "play_memory_game/1" do
    test "sample inputs" do
      assert play_memory_game([0, 3, 6]) == 436
      assert play_memory_game([1, 3, 2]) == 1
      assert play_memory_game([2, 1, 3]) == 10
      assert play_memory_game([1, 2, 3]) == 27
      assert play_memory_game([2, 3, 1]) == 78
      assert play_memory_game([3, 2, 1]) == 438
      assert play_memory_game([3, 1, 2]) == 1836
    end

    test "real input" do
      assert part_one() == 929
    end
  end
end
