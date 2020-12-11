defmodule Advent2020.Days.Day11Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day11
  alias Advent2020.DataStructures.{Grid, Vec2D}

  @sample """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  @sample_one """
  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##
  """

  @sample_two """
  #.LL.L#.##
  #LLLLLL.L#
  L.L.L..L..
  #LLL.LL.L#
  #.LL.LL.LL
  #.LLLL#.##
  ..L.L.....
  #LLLLLLLL#
  #.LLLLLL.L
  #.#LLLL.##
  """

  describe "parse/1" do
    test "can parse sample" do
      input = parse(@sample)
      assert Enum.count(Grid.coords(input)) == 100
    end
  end

  describe "perform_musical_chairs" do
    test "sample input" do
      input = parse(@sample)
      output = perform_musical_chairs(input, &transform_adjacent/2)
      count = count_occupied(output)
      assert count == 37
    end

    test "real input" do
      assert part_one() == 2319
    end
  end

  describe "perform_cycle/1" do
    test "sample input" do
      input = parse(@sample_one)
      output = perform_cycle(input, &transform_adjacent/2)
      as_s = to_s(output)
      assert as_s == String.trim(@sample_two)
    end
  end

  describe "neighbors/2" do
    test "sample" do
      input = parse(@sample_one)
      assert neighbors(input, Vec2D.new({1, 1})) == %{occupied_seat: 6, floor: 2}
      assert neighbors(input, Vec2D.new({0, 0})) == %{occupied_seat: 2, floor: 1, invalid_coord: 5}
      assert neighbors(input, Vec2D.new({9, 0})) == %{occupied_seat: 3, invalid_coord: 5}
    end
  end
end
