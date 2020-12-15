defmodule Advent2020.Days.Day15 do
  use Advent2020.Day, day: 15

  @input [16, 1, 0, 18, 12, 14, 19]

  def part_one do
    play_memory_game(@input, 2020)
  end

  def part_two do
    play_memory_game(@input, 30000000)
  end

  def play_memory_game(starting_numbers, target) do
    memory = starting_numbers
      |> Stream.with_index(1)
      |> Enum.into(%{})
    turn = map_size(memory) + 1
    previously_spoken = List.last(starting_numbers)
    play_turns(memory, turn, previously_spoken, target)
  end

  defp play_turns(_memory, turn, previously_spoken, target) when turn == target + 1, do: previously_spoken
  defp play_turns(memory, turn, previously_spoken, target) do
    previous_turn = turn - 1
    new_number = case Map.fetch(memory, previously_spoken) do
      {:ok, spoken_on} -> previous_turn - spoken_on
      :error -> 0
    end
    new_memory = Map.put(memory, previously_spoken, previous_turn)
    play_turns(new_memory, turn + 1, new_number, target)
  end
end
