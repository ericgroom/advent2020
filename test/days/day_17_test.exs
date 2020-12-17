defmodule Advent2020.Days.Day17Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day17

  @sample """
  .#.
  ..#
  ###
  """

  describe "parse/1" do
    test "can parse sample" do
      grid = parse(@sample)
      assert map_size(grid) == 9
      assert grid[{0, 0, 0}] == :inactive
      assert grid[{2, 2, 0}] == :active
    end
  end

  describe "run_cycle/1" do
    test "one cycle, sample input" do
      input = parse(@sample)
      output = run_n_cycles(input, 1)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 11
    end

    test "two cycles, sample input" do
      input = parse(@sample)
      output = run_n_cycles(input, 2)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 21
    end

    test "six cycled, sample input" do
      input = parse(@sample)
      output = run_n_cycles(input, 6)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 112
    end

    test "real input" do
      assert part_one() == 306
    end
  end

  describe "Vec3D.unit_vectors/0" do
    alias Advent2020.DataStructures.Vec3D

    test "didn't make a typo" do
      units = Vec3D.unit_vectors()
      unique_units = MapSet.new(units)
      assert Enum.count(units) == 26
      assert Enum.count(units) == MapSet.size(unique_units)
    end
  end
end
