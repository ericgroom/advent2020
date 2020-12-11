defmodule Advent2020.Days.Day10 do
  use Advent2020.Day, day: 10

  def part_one do
    differentials =
      @input
      |> Parser.parse_intlist()
      |> count_differentials()

    differentials[1] * differentials[3]
  end

  def part_two do
    @input
    |> Parser.parse_intlist()
    |> count_adapter_arrangements()
  end

  def count_adapter_arrangements(adapters) do
    chain = create_adapter_chain(adapters)
    {:ok, agent_pid} = Agent.start_link(fn -> %{} end)

    count_adapter_arrangements(
      List.first(chain),
      MapSet.new(chain),
      List.last(chain),
      agent_pid
    )
  end

  def count_adapter_arrangements(current, adapters, target, agent_pid) do
    current_memoized = get_memoized_path(current, agent_pid)

    cond do
      current == target ->
        1

      not is_nil(current_memoized) ->
        current_memoized

      true ->
        paths =
          neighbors(current, adapters)
          |> Enum.map(fn neighbor ->
            count_adapter_arrangements(neighbor, adapters, target, agent_pid)
          end)
          |> Enum.sum()

        put_memoized_path(current, paths, agent_pid)
        paths
    end
  end

  defp get_memoized_path(adapter, agent_pid) do
    Agent.get(agent_pid, fn memo -> Map.get(memo, adapter) end)
  end

  defp put_memoized_path(adapter, paths, agent_pid) do
    Agent.update(agent_pid, fn memo -> Map.put_new(memo, adapter, paths) end)
  end

  defp neighbors(current, adapters) do
    1..3
    |> Stream.map(fn inc -> current + inc end)
    |> Enum.filter(fn adapter -> MapSet.member?(adapters, adapter) end)
  end

  def count_differentials(adapters) do
    adapters
    |> create_adapter_chain()
    |> joltage_differentials()
    |> Enum.group_by(& &1)
    |> Enum.into(%{}, fn {x, xs} -> {x, Enum.count(xs)} end)
  end

  def joltage_differentials(chain) do
    pairwise = Stream.zip(chain, tl(chain))

    pairwise
    |> Enum.map(fn {previous, next} -> next - previous end)
  end

  def create_adapter_chain(adapters) do
    outlet_joltage = 0
    device_joltage = Enum.max(adapters) + 3
    [outlet_joltage | Enum.sort(adapters)] ++ [device_joltage]
  end
end
