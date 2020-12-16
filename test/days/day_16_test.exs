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
end
