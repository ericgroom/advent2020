defmodule Mix.Tasks.RunDays do
  use Mix.Task

  def run(_) do
    IO.puts Advent2020.Days.Day1.part_one()
  end
end
