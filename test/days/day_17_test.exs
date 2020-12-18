defmodule Advent2020.Days.Day17Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day17
  alias Advent2020.DataStructures.{Vec3D, Vec4D}

  @sample """
  .#.
  ..#
  ###
  """

  describe "parse/1" do
    test "can parse sample" do
      grid = parse(@sample, &Vec3D.partial/2)
      assert map_size(grid) == 9
      assert grid[{0, 0, 0}] == :inactive
      assert grid[{2, 2, 0}] == :active
    end
  end

  describe "run_cycle/1" do
    test "one cycle, sample input" do
      input = parse(@sample, &Vec3D.partial/2)
      output = run_n_cycles(input, Vec3D, 1)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 11
    end

    test "two cycles, sample input" do
      input = parse(@sample, &Vec3D.partial/2)
      output = run_n_cycles(input, Vec3D, 2)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 21
    end

    test "six cycled, sample input" do
      input = parse(@sample, &Vec3D.partial/2)
      output = run_n_cycles(input, Vec3D, 6)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 112
    end

    @tag :slow
    test "six cycled, sample, 4d" do
      input = parse(@sample, &Vec4D.partial/2)
      output = run_n_cycles(input, Vec4D, 6)
      active_count = Map.values(output) |> Enum.count(& &1 == :active)
      assert active_count == 848
    end

    test "real input" do
      assert part_one() == 306
    end

    @tag :slow
    test "real input 4d" do
      assert part_two() == 2572
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

  describe "Vec4D.unit_vectors/0" do
    alias Advent2020.DataStructures.Vec4D

    test "has expected number of units" do
      units = Vec4D.unit_vectors()
      unique_units = MapSet.new(units)
      assert Enum.count(units) == 80
      assert Enum.count(units) == MapSet.size(unique_units)
    end
  end
end
