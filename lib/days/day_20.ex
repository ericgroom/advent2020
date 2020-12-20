defmodule Advent2020.Days.Day20 do
  use Advent2020.Day, day: 20

  def parse(raw) do
    raw
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_image/1)
  end

  defp parse_image(raw) do
    [id_str, image] = String.split(raw, ":\n")

    id = id_str
        |> String.replace_prefix("Tile ", "")
        |> String.to_integer()

    image = image
    |> Parser.parse_grid(fn
      "." -> 0
      "#" -> 1
    end)

    {id, image}
  end
end
