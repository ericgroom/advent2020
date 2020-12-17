defmodule Advent2020.Days.Day16 do
  use Advent2020.Day, day: 16

  def part_one do
    {rules, _my_ticket, tickets} = parse(@input)
    sum_invalid_values(tickets, rules)
  end

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
    Enum.any?(rules, fn {_name, al..ah, bl..bh} ->
        (al <= value and value <= ah) or (bl <= value and value <= bh)
    end)
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
