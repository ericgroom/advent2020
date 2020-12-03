defmodule Mix.Tasks.RunDays do
  use Mix.Task

  def run(args) do
    {:ok, _} = :application.ensure_all_started(:advent2020)

    Advent2020.Days.all_days()
    |> run_days(args)
  end

  defp run_days(days, [day]) do
    {day, part} = parse_day_argument(day)
    opts = if part, do: [only: part], else: []

    days
    |> Enum.into(%{})
    |> Map.fetch!(day)
    |> run_day(opts)
  end

  defp run_days(days, []) do
    days
    |> Enum.map(fn {_day, module} -> module end)
    |> Enum.each(&run_day/1)
  end

  defp run_day(module, opts \\ [])

  defp run_day(module, only: part) do
    IO.inspect(apply(module, part, []))
  end

  defp run_day(module, []) do
    if Kernel.function_exported?(module, :part_one, 0), do: IO.inspect(module.part_one())
    if Kernel.function_exported?(module, :part_two, 0), do: IO.inspect(module.part_two())
  end

  defp parse_day_argument(day) do
    {day, remaining} = Integer.parse(day)

    case remaining do
      "a" -> {day, :part_one}
      "b" -> {day, :part_two}
      "" -> {day, nil}
    end
  end
end
