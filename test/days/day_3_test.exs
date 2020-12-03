defmodule Advent2020.Days.Day3Test do
  use ExUnit.Case, async: true

  alias Advent2020.DataStructures.{CycledGrid, Coord2D}
  import Advent2020.Days.Day3

  @sample_input """
        ..##.......
        #...#...#..
        .#....#..#.
        ..#.#...#.#
        .#...##..#.
        ..#.##.....
        .#.#.#....#
        .#........#
        #.##...#...
        #...##....#
        .#..#...#.#
  """

  describe "parse" do
    test "input can be parsed into CycledGrid" do
      grid = parse(@sample_input)
      assert grid.row_length == 11
      assert CycledGrid.at(grid, %Coord2D{x: 0, y: 0}) == :empty
      assert CycledGrid.at(grid, %Coord2D{x: 0, y: 1}) == :tree
      assert CycledGrid.at(grid, %Coord2D{x: 13, y: 0}) == :tree
    end
  end

  describe "count_trees/2" do
    test "sample input" do
      grid = parse(@sample_input)
      assert count_trees(grid, {3, 1}) == 7
    end

    test "real input" do
      assert part_one() == 282
    end
  end
end
