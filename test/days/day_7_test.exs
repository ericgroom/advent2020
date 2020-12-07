defmodule Advent2020.Days.Day7Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day7

  @sample %{
    "light red" => %{"bright white" => 1, "muted yellow" => 2},
    "dark orange" => %{"bright white" => 3, "muted yellow" => 4},
    "bright white" => %{"shiny gold" => 1},
    "muted yellow" => %{"shiny gold" => 2, "faded blue" => 9},
    "shiny gold" => %{"dark olive" => 1, "vibrant plum" => 2},
    "dark olive" => %{"faded blue" => 3, "dotted black" => 4},
    "vibrant plum" => %{"faded blue" => 5, "dotted black" => 6},
    "faded blue" => %{},
    "dotted black" => %{}
  }

  describe "recursive_bags_containing/2" do
    test "sample input" do
      expected = MapSet.new(["light red", "dark orange", "bright white", "muted yellow"])
      actual = recursive_bags_containing("shiny gold", @sample)
      assert actual == expected
    end
  end

  describe "count_total_child_bags_contained/2" do
    test "original sample input" do
      assert count_total_child_bags_contained("shiny gold", @sample) == 32
    end

    test "new sample input" do
      raw = """
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
      """

      input = parse(raw)
      assert count_total_child_bags_contained("shiny gold", input) == 126
    end
  end
end
