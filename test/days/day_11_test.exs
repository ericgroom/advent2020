defmodule Advent2020.Days.Day11Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day11
  alias Advent2020.DataStructures.{Grid}

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
      output = perform_musical_chairs(input, &adjacent_neighbors/2, 4)
      count = count_occupied(output)
      assert count == 37
    end

    @tag :slow
    test "real input" do
      assert part_one() == 2319
    end

    test "sample input part 2" do
      input = parse(@sample)
      output = perform_musical_chairs(input, &visible_neighbors/2, 5)
      count = count_occupied(output)
      assert count == 26
    end

    @tag :slow
    test "real input part two" do
      assert part_two() == 2117
    end
  end

  describe "perform_cycle/3" do
    test "sample input" do
      input = parse(@sample_one)
      output = perform_cycle(input, &adjacent_neighbors/2, 4)
      assert Grid.equals?(output, parse(@sample_two))
    end
  end
end
