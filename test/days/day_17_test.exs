defmodule Advent2020.Days.Day17Test do
  use ExUnit.Case, async: true

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
