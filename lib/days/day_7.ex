defmodule Advent2020.Days.Day7 do
  use Advent2020.Day, day: 7

  import Inline

  test part_one(), is: 164

  def part_one() do
    bag_rules = parse(@input)

    recursive_bags_containing("shiny gold", bag_rules)
    |> MapSet.size()
  end

  test part_two(), is: 7872

  def part_two() do
    bag_rules = parse(@input)

    count_total_child_bags_contained("shiny gold", bag_rules)
  end

  def parse(raw) do
    raw
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_definition/1)
    |> Enum.into(%{})
  end

  defp parse_definition(definition) do
    [parent, children] = String.trim(definition) |> String.split("contain")
    parent = parse_parent(parent |> String.trim())
    children = parse_children(children |> String.trim())
    {parent, children}
  end

  defp parse_parent(parent) do
    parent
    |> String.trim()
    |> remove_bag_suffix()
  end

  defp parse_children("no other bags."), do: %{}

  defp parse_children(children) do
    children
    |> String.replace_suffix(".", "")
    |> String.split(", ")
    |> Enum.map(&parse_child/1)
    |> Enum.reduce(%{}, fn {count, child}, acc -> Map.put_new(acc, child, count) end)
  end

  defp parse_child(child) do
    {count, bag_untrimmed} =
      child
      |> remove_bag_suffix()
      |> Integer.parse()

    {count, bag_untrimmed |> String.trim()}
  end

  defp remove_bag_suffix(definition) do
    definition
    |> String.replace_suffix(" bag", "")
    |> String.replace_suffix(" bags", "")
  end

  def recursive_bags_containing(bag_name, bag_rules) do
    bags_containing_target =
      bag_rules
      |> Enum.filter(fn {_outer, children} ->
        Map.has_key?(children, bag_name)
      end)
      |> Enum.map(fn {bag, _children} -> bag end)
      |> Enum.into(MapSet.new())

    bags_containing_parents =
      bags_containing_target
      |> Enum.map(fn bag -> recursive_bags_containing(bag, bag_rules) end)
      |> Enum.reduce(MapSet.new(), &MapSet.union/2)

    MapSet.union(bags_containing_target, bags_containing_parents)
  end

  def count_total_child_bags_contained(container_bag, bag_rules) do
    children = bag_rules[container_bag]

    children
    |> Enum.map(fn {child, count} ->
      count + count * count_total_child_bags_contained(child, bag_rules)
    end)
    |> Enum.sum()
  end
end
