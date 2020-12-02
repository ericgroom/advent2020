defmodule Advent2020.Day do
  @callback part_one() :: any()
  @callback part_two() :: any()

  defmacro __using__([day: day, input: input_file]) do
    quote do
      @behaviour unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :day, persist: true)
      Module.put_attribute(__MODULE__, :day, unquote(day))

      @input Path.join(Path.dirname(__ENV__.file), unquote(input_file)) |> File.read!()

      alias Advent2020.Parser
    end
  end
end
