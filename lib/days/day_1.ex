defmodule Advent2020.Days.Day1 do

  @input Path.join(Path.dirname(__ENV__.file), "input.txt") |> File.read!()

  def part_one do
    @input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> find_expense_anomoly()
  end

  def find_expense_anomoly items do
    anomoly_sum = 2020
    items_set = MapSet.new(items)
    pairs = Enum.map(items, fn item ->
      counterpart = anomoly_sum - item
      if MapSet.member?(items_set, counterpart) do
        {:has_counterpart, {item, counterpart}}
      else
        {:no_counterpart, item}
      end
    end)

    {:has_counterpart, {expense_one, expense_two}} = Enum.find(pairs, fn pair ->
      case pair do
        {:has_counterpart, {_expense, _counterpart}} ->
          true
        {:no_counterpart, _expense} ->
          false
      end
    end)

    expense_one * expense_two
  end
end
