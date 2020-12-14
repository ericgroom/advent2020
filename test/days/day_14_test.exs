defmodule Advent2020.Days.Day14Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day14

  describe "create mask" do
    test "sanity check" do
      {and_mask, or_mask} = create_mask("XX1X0XX1")
      assert or_mask == 0b00100001
      assert and_mask == 0b11110111
    end

     test "apply mask" do
      mask = create_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      input = String.to_integer("000000000000000000000000000000001011", 2)
      expected = String.to_integer("000000000000000000000000000001001001", 2)
      output = apply_mask(mask, input)
      assert output == expected
    end
  end

  describe "run_program/1" do
    test "sample input" do
      input = [
        {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
        {:store, 8, 11},
        {:store, 7, 101},
        {:store, 8, 0}
      ]
      output = run_program(input)
      assert sum_memory(output) == 165
    end

    test "real input" do
      assert part_one() == 13476250121721
    end
  end
end
