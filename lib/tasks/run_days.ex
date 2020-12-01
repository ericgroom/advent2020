defmodule Mix.Tasks.RunDays do
  use Mix.Task

  def run(stuff) do
    {:ok, _started} = Application.ensure_all_started(:advent2020)
    IO.inspect :application.loaded_applications()
    IO.inspect Advent2020.Days.all_days()
    IO.inspect stuff
    IO.puts Advent2020.Days.Day1.part_one()
    IO.puts Advent2020.Days.Day1.part_two()
  end
end
