defmodule Advent2020.Days.Day5Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day5

  describe "seat_number/2" do
    test "sample input" do
      assert seat_number("FBFBBFFRLR", {0..127, 0..7}) == {44, 5}
      assert seat_number("BFFFBBFRRR", {0..127, 0..7}) == {70, 7}
      assert seat_number("FFFBBBFRRR", {0..127, 0..7}) == {14, 7}
      assert seat_number("BBFFBBFRLL", {0..127, 0..7}) == {102, 4}
    end

    test "real input" do
      assert part_one() == 828
    end
  end

  describe "seat_id/1" do
    test "sample input" do
      assert seat_id({44, 5}) == 357
      assert seat_id({70, 7}) == 567
      assert seat_id({14, 7}) == 119
      assert seat_id({102, 4}) == 820
    end
  end

  describe "find_my_seat/2" do
    test "real input" do
      assert part_two() == 565
    end
  end
end
