defmodule Advent2020.Days.Day12 do
  use Advent2020.Day, day: 12

  # following mathematical coordinates y+ north y- south x+ east x- west

  def part_one do
    @input
    |> parse()
    |> follow_navigation()
    |> distance_from_start()
  end

  def part_two do
    @input
    |> parse()
    |> follow_waypoint_navigation()
    |> distance_from_start()
  end

  def parse(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(&parse_instruction/1)
  end

  def distance_from_start({x, y, _heading}) do
    abs(x) + abs(y)
  end

  def distance_from_start({{x, y}, {_wx, _wy}}) do
    abs(x) + abs(y)
  end

  def follow_navigation(chart) do
    Enum.reduce(chart, {0, 0, :east}, fn adjustment, pos ->
      adjust_ship_position(pos, adjustment)
    end)
  end

  def follow_waypoint_navigation(chart) do
    Enum.reduce(chart, {{0, 0}, {10, 1}}, fn adjustment, pos ->
      adjust_ship_waypoint_pos(pos, adjustment)
    end)
  end


  defp parse_instruction({"N", amount}), do: {:north, String.to_integer(amount)}
  defp parse_instruction({"S", amount}), do: {:south, String.to_integer(amount)}
  defp parse_instruction({"E", amount}), do: {:east, String.to_integer(amount)}
  defp parse_instruction({"W", amount}), do: {:west, String.to_integer(amount)}
  defp parse_instruction({"F", amount}), do: {:forward, String.to_integer(amount)}
  defp parse_instruction({"L", amount}), do: {:left, String.to_integer(amount)}
  defp parse_instruction({"R", amount}), do: {:right, String.to_integer(amount)}

  defp adjust_ship_position({x, y, heading}, {:north, amount}), do: {x, y + amount, heading}
  defp adjust_ship_position({x, y, heading}, {:south, amount}), do: {x, y - amount, heading}
  defp adjust_ship_position({x, y, heading}, {:east, amount}), do: {x - amount, y, heading}
  defp adjust_ship_position({x, y, heading}, {:west, amount}), do: {x + amount, y, heading}
  defp adjust_ship_position({x, y, heading}, {:forward, amount}), do: adjust_ship_position({x, y, heading}, {heading, amount})
  defp adjust_ship_position({x, y, heading}, {:left = dir, degrees}), do: {x, y, rotate(heading, degrees, dir)}
  defp adjust_ship_position({x, y, heading}, {:right = dir, degrees}), do: {x, y, rotate(heading, degrees, dir)}

  defp rotate(heading, degrees, direction) do
    encoded_deg = encode_degrees(degrees) * sign(direction)
    encoded_heading = encode_heading(heading)
    new_heading = rem(encoded_heading + encoded_deg + 4, 4)
    decode_heading(new_heading)
  end

  defp sign(:left), do: -1
  defp sign(:right), do: 1

  defp encode_degrees(degrees), do: div(degrees, 90)

  defp encode_heading(:north), do: 0
  defp encode_heading(:east), do: 1
  defp encode_heading(:south), do: 2
  defp encode_heading(:west), do: 3

  defp decode_heading(0), do: :north
  defp decode_heading(1), do: :east
  defp decode_heading(2), do: :south
  defp decode_heading(3), do: :west


  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:north, amount}), do: {{sx, sy}, {wx, wy + amount}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:south, amount}), do: {{sx, sy}, {wx, wy - amount}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:east, amount}), do: {{sx, sy}, {wx + amount, wy}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:west, amount}), do: {{sx, sy}, {wx - amount, wy}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:forward, amount}), do: {{sx + (wx * amount), sy + (wy * amount)}, {wx, wy}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:left, 90}), do: {{sx, sy}, {-wy, wx}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:left, 180}), do: {{sx, sy}, {-wx, -wy}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:left, 270}), do: {{sx, sy}, {wy, -wx}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:right, 90}), do: {{sx, sy}, {wy, -wx}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:right, 180}), do: {{sx, sy}, {-wx, -wy}}
  def adjust_ship_waypoint_pos({{sx, sy}, {wx, wy}}, {:right, 270}), do: {{sx, sy}, {-wy, wx}}
end
