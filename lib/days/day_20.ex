defmodule Advent2020.Days.Day20 do
  use Advent2020.Day, day: 20

  def part_one do
    @input
    |> parse()
    |> find_corners()
    |> Enum.reduce(1, &*/2)
  end

  def find_corners(images) do
    images
    |> Enum.map(fn {id, image} -> {id, edges(image)} end)
    |> create_edge_registry()
    |> Map.values()
    |> Enum.filter(fn set -> MapSet.size(set) >= 2 end)
    |> Enum.flat_map(fn set -> MapSet.to_list(set) end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_id, freq} -> freq == 2 end)
    |> Enum.map(fn {id, _freq} -> id end)
  end

  def create_edge_registry(images, registry \\ %{})
  def create_edge_registry([], registry), do: registry
  def create_edge_registry([image | rest] = _images, registry) do
    {id, edges} = image

    registry = edges
    |> Enum.reduce(registry, fn edge, registry -> register_edge(edge, id, registry) end)

    create_edge_registry(rest, registry)
  end

  defp register_edge(edge, id, registry) do
    if Map.has_key?(registry, Enum.reverse(edge)) do
      Map.update!(registry, Enum.reverse(edge), fn set -> MapSet.put(set, id) end)
    else
      Map.update(registry, edge, MapSet.new([id]), fn set -> MapSet.put(set, id) end)
    end
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
    [id_str, image] = String.split(String.trim(raw), ":\n")

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
