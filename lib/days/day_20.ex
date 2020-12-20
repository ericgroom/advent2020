defmodule Advent2020.Days.Day20 do
  use Advent2020.Day, day: 20

  def part_one do
    @input
    |> parse()
    |> create_edge_registry()
    |> find_corners()
    |> Enum.reduce(1, &*/2)
  end

  def find_tile_arrangement(images) do
    edge_registry = create_edge_registry(images)
    images = Enum.into(images, %{})
    corners = find_corners(edge_registry)
    [corner | _rest] = corners

    [top, right, bottom, left] = Map.get(images, corner) |> edges()
    top_counterpart    = edge_counterpart(top, corner, edge_registry)
    right_counterpart  = edge_counterpart(right, corner, edge_registry)
    bottom_counterpart = edge_counterpart(bottom, corner, edge_registry)
    left_counterpart   = edge_counterpart(left, corner, edge_registry)

    top_image = if top_counterpart do
      image = Map.get(images, top_counterpart)

      [ctop, cright, cbottom, cleft] = edges(image)
      transform = cond do
        ctop == top -> {2, :horizontal}
        Enum.reverse(ctop) == top -> {2, :none}
        cright == top -> {1, :horizontal}
        Enum.reverse(cright) == top -> {1, :none}
        cbottom == top -> {0, :none}
        Enum.reverse(bottom) == top -> {0, :horizontal}
        cleft == top -> {3, :none}
        Enum.reverse(cleft) == top -> {3, :horizontal}
      end

      {top_counterpart, apply_transform(image, transform)}
    end

    right_image = if right_counterpart do
      image = Map.get(images, right_counterpart)

      [ctop, cright, cbottom, cleft] = edges(image)
      transform = cond do
        ctop == right -> {3, :vertical}
        Enum.reverse(ctop) == right -> {3, :none}
        cright == right -> {2, :vertical}
        Enum.reverse(cright) == right -> {2, :none}
        cbottom == right -> {1, :none}
        Enum.reverse(bottom) == right -> {1, :vertical}
        cleft == right -> {0, :none}
        Enum.reverse(cleft) == right -> {0, :vertical}
      end

      {right_counterpart, apply_transform(image, transform)}
    end

    IO.inspect right_image
    IO.inspect Map.get(images, corner)
  end

  defp apply_transform(image, {rotations, reflection}) do
    rotated = case rotations do
                0 -> image
                1 -> image |> rotate()
                2 -> image |> rotate() |> rotate()
                3 -> image |> rotate() |> rotate()
    end

    case reflection do
      :none -> rotated
      :horizontal -> raise "todo"
      :vertical -> raise "todo"
    end
  end

  defp transpose(image) do
    image
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp rotate(image) do
    image
    |> transpose()
    |> Enum.map(&Enum.reverse/1)
  end

  def edge_counterpart(edge, id, registry) do
    normal = Map.get(registry, edge, MapSet.new())
    inverse = Map.get(registry, Enum.reverse(edge), MapSet.new())
    counterparts = MapSet.union(normal, inverse)
      |> MapSet.difference(MapSet.new([id]))

    if MapSet.size(counterparts) > 1, do: raise "has more than 1 counterpart"

    MapSet.to_list(counterparts) |> List.first()
  end

  def find_corners(registry) do
    registry
    |> Map.values()
    |> Enum.filter(fn set -> MapSet.size(set) >= 2 end)
    |> Enum.flat_map(fn set -> MapSet.to_list(set) end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_id, freq} -> freq == 2 end)
    |> Enum.map(fn {id, _freq} -> id end)
  end

  def create_edge_registry(images, registry \\ %{})
  def create_edge_registry([], registry), do: registry
  def create_edge_registry([{id, image} | rest] = _images, registry) do
    registry = edges(image)
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
