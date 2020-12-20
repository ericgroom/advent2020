defmodule Advent2020.Days.Day20 do
  use Advent2020.Day, day: 20

  def part_one do
    @input
    |> parse()
    |> test_spacially_independent()
  end

  def test_spacially_independent(images) do
    images
    |> Enum.map(fn {_id, image} -> image end)
    |> Enum.flat_map(fn image ->
      edges(image)
      |> Enum.flat_map(fn edge ->
        [edge, Enum.reverse(edge)]
      end)
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.frequencies()
  end

  def edges(image) do
    top = List.first(image)
    bottom = List.last(image)
    left = Enum.map(image, &List.first/1)
    right = Enum.map(image, &List.last/1)
    [top, right, bottom, left]
  end

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
