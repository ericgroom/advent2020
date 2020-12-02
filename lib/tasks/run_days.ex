defmodule Mix.Tasks.RunDays do
  use Mix.Task

  def run(args) do
    Mix.Tasks.Run.run(args)

    Advent2020.Days.all_days()
    |> Enum.map(fn {_day, module} -> module end)
    |> Enum.each(fn module ->
      if Kernel.function_exported?(module, :part_one, 0), do: IO.inspect(module.part_one())
      if Kernel.function_exported?(module, :part_two, 0), do: IO.inspect(module.part_two())
    end)
  end
end
