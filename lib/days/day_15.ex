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
    memory = :ets.new(:memory, [:set, :private])
    starting_numbers
      |> Stream.with_index(1)
      |> Enum.each(fn entry -> :ets.insert(memory, entry) end)
    turn = Enum.count(starting_numbers) + 1
    previously_spoken = List.last(starting_numbers)
    play_turns(memory, turn, previously_spoken, target)
  end

  defp play_turns(_memory, turn, previously_spoken, target) when turn == target + 1, do: previously_spoken
  defp play_turns(memory, turn, previously_spoken, target) do
    previous_turn = turn - 1
    new_number = case :ets.lookup(memory, previously_spoken) do
      [{_key, spoken_on}] -> previous_turn - spoken_on
      [] -> 0
    end
    :ets.insert(memory, {previously_spoken, previous_turn})
    play_turns(memory, turn + 1, new_number, target)
  end
end
