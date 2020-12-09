defmodule Advent2020.Days.Day9Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day9

  @sample [
    35,
    20,
    15,
    25,
    47,
    40,
    62,
    55,
    65,
    95,
    102,
    117,
    150,
    182,
    127,
    219,
    299,
    277,
    309,
    576
  ]

  describe "find_xmas_weakness/2" do
    test "sample input" do
      assert find_xmas_weakness(@sample, 5) == 127
    end

    test "real input" do
      assert part_one() == 1_504_371_145
    end
  end

  describe "find_contiguous_sum/2" do
    test "sample input" do
      assert find_contiguous_sum(@sample, 127) == [40, 47, 25, 15]
    end
  end

  describe "find_summed_weakness/2" do
    test "sample input" do
      assert find_summed_weakness(@sample, 5) == 62
    end

    test "real input" do
      assert part_two() == 183_278_487
    end
  end
end
