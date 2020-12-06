defmodule Advent2020.Days.Day6Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day6

  @sample_input """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  describe "parse/1" do
    test "sample input" do
      output = [
        [["a", "b", "c"]],
        [["a"], ["b"], ["c"]],
        [["a", "b"], ["a", "c"]],
        [["a"], ["a"], ["a"], ["a"]],
        [["b"]]
      ]

      assert parse(@sample_input) == output
    end
  end

  describe "declaration_for_group anyone" do
    test "sample input" do
      declarations =
        @sample_input
        |> parse()
        |> Enum.map(fn group -> declaration_for_group(group, &anyone_combinator/1) end)
        |> Enum.map(&MapSet.to_list/1)

      assert declarations == [
               ["a", "b", "c"],
               ["a", "b", "c"],
               ["a", "b", "c"],
               ["a"],
               ["b"]
             ]
    end

    test "real input" do
      assert part_one() == 6630
    end
  end

  describe "declaration_for_group everyone" do
    test "sample input" do
      declarations =
        @sample_input
        |> parse()
        |> Enum.map(fn group -> declaration_for_group(group, &everyone_combinator/1) end)
        |> Enum.map(&MapSet.to_list/1)

      assert declarations == [
               ["a", "b", "c"],
               [],
               ["a"],
               ["a"],
               ["b"]
             ]
    end

    test "real input" do
      assert part_two() == 3437
    end
  end
end
