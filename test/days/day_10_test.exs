defmodule Advent2020.Days.Day10Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day10

  @small_sample [
    16,
    10,
    15,
    5,
    1,
    11,
    7,
    19,
    6,
    12,
    4
  ]

  @large_sample [
    28,
    33,
    18,
    42,
    31,
    14,
    46,
    20,
    48,
    47,
    24,
    23,
    49,
    45,
    19,
    38,
    39,
    11,
    1,
    32,
    25,
    35,
    8,
    17,
    7,
    9,
    4,
    2,
    34,
    10,
    3
  ]

  describe "count_differentials/1" do
    test "small sample input" do
      assert count_differentials(@small_sample) == %{
               1 => 7,
               3 => 5
             }
    end

    test "large sample input" do
      assert count_differentials(@large_sample) == %{
               1 => 22,
               3 => 10
             }
    end

    test "real input" do
      assert part_one() == 2040
    end
  end

  describe "count_adapter_arrangements/1" do
    test "small sample" do
      assert count_adapter_arrangements(@small_sample) == 8
    end

    test "large sample" do
      assert count_adapter_arrangements(@large_sample) == 19208
    end

    test "real input" do
      assert part_two() == 28346956187648
    end
  end
end
