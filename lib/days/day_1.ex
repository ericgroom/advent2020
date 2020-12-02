defmodule Advent2020.Days.Day1 do

  use Advent2020.Day, day: 1

  @input Path.join(Path.dirname(__ENV__.file), "day_1_input.txt") |> File.read!()

  def part_one do
    @input
    |> Parser.parse_intlist()
    |> find_expense_anomoly()
  end

  def part_two do
    @input
    |> Parser.parse_intlist()
    |> find_other_anomoly()
  end

  @anomoly_sum 2020

  def find_expense_anomoly items do
    pairs = permutations_exluding_self(items)

    {expense_one, expense_two} = Enum.find(pairs, fn {x, y} ->
      x + y == @anomoly_sum
    end)

    expense_one * expense_two
  end

  def find_other_anomoly items do
    items_set = MapSet.new(items)
    pairs = permutations_exluding_self(items)

    {expense_one, expense_two} = Enum.find(pairs, fn {x, y} ->
      counterpart = @anomoly_sum - x - y
      MapSet.member?(items_set, counterpart)
    end)

    expense_three = @anomoly_sum - expense_one - expense_two
    expense_one * expense_two * expense_three
  end

  defp permutations_exluding_self items do
    enumerated_items = Enum.with_index(items)
    enumerated_items
    |> Enum.flat_map(fn {item, index} ->
      Enum.map(enumerated_items, fn {second_item, second_index} ->
        if index == second_index, do: nil, else: {item, second_item}
      end)
    end)
    |> Enum.filter(fn item -> item != nil end)
  end
end
