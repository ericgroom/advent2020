defmodule Advent2020.Days.Day14 do
  use Advent2020.Day, day: 14
  use Bitwise

  def part_one do
    @input
    |> parse()
    |> run_program()
    |> sum_memory()
  end

  def part_two do
    @input
    |> parse()
    |> run_v2_program()
    |> sum_memory()
  end

  def parse(raw) do
    mask_pattern = ~r/^(mask) = (\w+)$/
    store_pattern = ~r/^(mem)\[(\d+)\] = (\d+)$/

    raw
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      cond do
        Regex.match?(mask_pattern, line) ->
          [_all, "mask", mask] = Regex.run(mask_pattern, line)
          {:mask, mask}
        Regex.match?(store_pattern, line) ->
          [_all, "mem", addr, value] = Regex.run(store_pattern, line)
          {:store, String.to_integer(addr), String.to_integer(value)}
        true ->
          raise "no match for '#{line}'"
      end
    end)
  end

  def sum_memory(memory) do
    memory
    |> Map.values()
    |> Enum.sum()
  end

  def run_v2_program(instructions, mask \\ nil, memory \\ %{})
  def run_v2_program([], _mask, memory), do: memory
  def run_v2_program([h|t], mask, memory) do
    case h do
      {:mask, new_mask} ->
        run_v2_program(t, create_v2_mask(new_mask), memory)
      {:store, addr, value} ->
        masked_addrs = apply_v2_mask(mask, addr)
        new_mem = Enum.reduce(masked_addrs, memory, fn addr, acc -> Map.put(acc, addr, value) end)
        run_v2_program(t, mask, new_mem)
    end
  end

  def run_program(instructions, mask \\ nil, memory \\ %{})
  def run_program([], _mask, memory), do: memory
  def run_program([h|t], mask, memory) do
    case h do
      {:mask, new_mask} ->
        run_program(t, create_mask(new_mask), memory)
      {:store, addr, value} ->
        masked = apply_mask(mask, value)
        run_program(t, mask, Map.put(memory, addr, masked))
    end
  end

  def apply_v2_mask(mask, num) do
    mask
    |> Enum.map(&apply_mask(&1, num))
  end

  def create_v2_mask(str) when is_binary(str) do
    # We can leverage the v1 implementation by doing the following translation
    # 0 -> X (X left unchanged in original)
    # 1 -> 1 (1 overwrote in original)
    # X -> [1, 0] recurse on both possible values
    create_v2_masks(String.graphemes(str))
  end

  defp create_v2_masks(bits, so_far \\ "")
  defp create_v2_masks([], so_far), do: [create_mask(so_far)]
  defp create_v2_masks([h|t], so_far) do
    case h do
      "1" ->
        create_v2_masks(t, so_far <> "1")
      "0" ->
        create_v2_masks(t, so_far <> "X")
      "X" ->
        create_v2_masks(t, so_far <> "1") ++ create_v2_masks(t, so_far <> "0")
    end
  end

  def apply_mask({and_mask, or_mask}, num) do
    (num &&& and_mask) ||| or_mask
  end

  def create_mask(str) do
    # Creates an AND mask and an OR mask
    # AND mask is all 1s except where input is 0
    # OR mask is all 0s except where input is 1
    tokens = str |> String.graphemes()
    and_mask = create_and_mask(tokens)
    or_mask = create_or_mask(tokens)
    {and_mask, or_mask}
  end

  defp create_and_mask(tokens, so_far \\ 0)
  defp create_and_mask([], so_far), do: so_far
  defp create_and_mask([h|t], so_far) do
    case h do
      "0" ->
        create_and_mask(t, so_far <<< 1)
      _ ->
        create_and_mask(t, (so_far <<< 1) + 1)
    end
  end

  defp create_or_mask(tokens, so_far \\ 0)
  defp create_or_mask([], so_far), do: so_far
  defp create_or_mask([h|t], so_far) do
    case h do
      "1" ->
        create_or_mask(t, (so_far <<< 1) + 1)
      _ ->
        create_or_mask(t, so_far <<< 1)
    end
  end
end
