defmodule Advent2020.Days.Day16Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day16

  @sample """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  describe "parse/1" do
    test "can parse sample input" do
      assert {rules, my_ticket, tickets} = parse(@sample)
      assert rules == [
        {"class", 1..3, 5..7},
        {"row", 6..11, 33..44},
        {"seat", 13..40, 45..50},
      ]
      assert my_ticket == [7, 1, 14]
      assert tickets = [
        [7, 3, 47],
        [40, 4, 50],
        [55, 2, 20],
        [38, 6, 12],
      ]
    end
  end

  describe "sum_invalid_values/2" do
    test "sample input" do
        {rules, _my_ticket, tickets} = parse(@sample)
        assert sum_invalid_values(tickets, rules) == 71
    end

    test "real input" do
      assert part_one() == 25916
    end
  end

  describe "departure_values/3" do
    test "reddit input" do
      input = """
      class: 0-1 or 4-19
      departure row: 0-5 or 8-19
      departure seat: 0-13 or 16-19

      your ticket:
      11,12,13

      nearby tickets:
      3,9,18
      15,1,5
      5,14,9
      """
      {rules, my_ticket, tickets} = parse(input)
      assert departure_values(rules, my_ticket, tickets) == 143
    end

    test "real input" do
      assert part_two() == 2564529489989
    end
  end

  describe "determine field positions" do
    # test "determine_single_field_position/1" do
    #   tickets = [
    #     [3, 9, 18],
    #     [15, 1, 5],
    #     [5, 14, 9]
    #   ]
    #   assert determine_single_field_position(tickets, {"row", 0..5, 8..19}) == 0
    #   assert determine_single_field_position(tickets, {"class", 0..1, 4..19}) == 1
    #   assert determine_single_field_position(tickets, {"seat", 0..13, 16..19}) == 2
    # end

    # test "determine_field_order" do
    #   tickets = [
    #     [3, 9, 18],
    #     [15, 1, 5],
    #     [5, 14, 9]
    #   ]
    #   rules = [
    #     {"row", 0..5, 8..19},
    #     {"class", 0..1, 4..19},
    #     {"seat", 0..13, 16..19},
    #   ]
    #   assert determine_field_order(tickets, rules) == ["row", "class", "seat"]
    # end
  end
end
