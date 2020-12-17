defmodule Advent2020.Days.Day16 do
  use Advent2020.Day, day: 16

  def part_one do
    {rules, _my_ticket, tickets} = parse(@input)
    sum_invalid_values(tickets, rules)
  end

  def part_two do
    {rules, my_ticket, tickets} = parse(@input)
    departure_values(rules, my_ticket, tickets)
  end

  def departure_values(rules, my_ticket, tickets) do
    {valid, _invalid} = partition_valid_invalid(tickets, rules)
    field_order = determine_field_order(rules, valid)

    Enum.zip(field_order, my_ticket)
    |> Enum.filter(fn {field, _value} -> String.starts_with?(field, "departure") end)
    |> Enum.map(fn {_field, value} -> value end)
    |> Enum.reduce(1, &*/2)
  end

  defp determine_field_order(rules, tickets) do
    columns = 0..(Enum.count(tickets)-1)

    rules_possible_columns = rules
      |> Enum.map(fn rule -> {rule, MapSet.new(columns)} end)
      |> Enum.map(fn {rule, columns} ->
        valid_columns = columns
          |> Enum.filter(&rule_valid_for_column?(rule, &1, tickets))
          |> Enum.into(MapSet.new())
        {rule, valid_columns}
      end)

    reduce_valid_columns_for_rules(rules_possible_columns)
    |> Enum.map(fn {rule, columns} ->
      if MapSet.size(columns) != 1, do: raise "#{inspect rule} has #{inspect columns}"
      {rule, columns |> MapSet.to_list() |> List.first()}
    end)
    |> Enum.sort_by(fn {_rule, column} -> column end)
    |> Enum.map(fn {{name, _, _}, _column} -> name end)
  end

  defp reduce_valid_columns_for_rules(rules_columns) do
    all_done = Enum.all?(rules_columns, fn {rule, columns} -> MapSet.size(columns) == 1 end)
    if all_done do
      rules_columns
    else
      # find rule which only has one element
      # remove that element from all others
      # repeat until done
      with_one = rules_columns
      |> Enum.map(fn {_rule, columns} -> columns end)
      |> Enum.filter(fn columns -> MapSet.size(columns) == 1 end)
      |> Enum.reduce(MapSet.new(), &MapSet.union/2)

      new_rules_columns = rules_columns
      |> Enum.map(fn {rule, columns} ->
        if MapSet.size(columns) > 1 do
          {rule, MapSet.difference(columns, with_one)}
        else
          {rule, columns}
        end
      end)

      reduce_valid_columns_for_rules(new_rules_columns)
    end
  end

  defp rule_valid_for_column?(rule, column, tickets) do
    column = Enum.map(tickets, fn ticket -> Enum.at(ticket, column) end)
    Enum.all?(column, &valid_value_rule?(&1, rule))
  end

  def sum_invalid_values(tickets, rules) do
    {_valid, invalid} = partition_valid_invalid(tickets, rules)

    invalid_values = for ticket <- invalid, value <- ticket, not valid_value?(value, rules), do: value
    Enum.sum(invalid_values)
  end

  defp partition_valid_invalid(tickets, rules) do
    Enum.split_with(tickets, &valid_ticket?(&1, rules))
  end

  defp valid_ticket?(ticket, rules) do
    Enum.all?(ticket, fn value -> valid_value?(value, rules) end)
  end

  defp valid_value?(value, rules) do
    Enum.any?(rules, &valid_value_rule?(value, &1))
  end

  defp valid_value_rule?(value, {_name, al..ah, bl..bh}) do
    (al <= value and value <= ah) or (bl <= value and value <= bh)
  end

  def parse(raw) do
    [rules, my_ticket, tickets] = String.split(raw, "\n\n", trim: true)
    rules = parse_rules(rules)
    my_ticket = parse_tickets(my_ticket) |> List.first()
    tickets = parse_tickets(tickets)
    {rules, my_ticket, tickets}
  end

  @rule ~r/^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$/
  defp parse_rules(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(fn rule_str ->
      [_all, field, range_fl, range_fh, range_sl, range_sh]
        = Regex.run(@rule, rule_str)
      r = fn a, b -> String.to_integer(a)..String.to_integer(b) end

      {field, r.(range_fl, range_fh), r.(range_sl, range_sh)}
    end)
  end

  defp parse_tickets(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn values ->
      values
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
