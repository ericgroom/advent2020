defmodule Advent2020.Days.Day12Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day12

  @sample [
    {:forward, 10},
    {:north, 3},
    {:forward, 7},
    {:right, 90},
    {:forward, 11}
  ]

  describe "follow_navigation/1" do
    test "sample input" do
      assert follow_navigation(@sample) |> distance_from_start() == 25
    end

    test "rotation" do
      to_north = [{:left, 90}]
      assert follow_navigation(to_north) == {0, 0, :north}

      to_south_left = [{:left, 270}]
      assert follow_navigation(to_south_left) == {0, 0, :south}

      to_south_right = [{:right, 90}]
      assert follow_navigation(to_south_right) == {0, 0, :south}
    end

    test "real input" do
      assert part_one() == 2879
    end
  end

  describe "follow_waypoint_navigation/1" do
    test "sample input" do
      assert follow_waypoint_navigation(@sample) |> distance_from_start() == 286
    end
  end
end
