defmodule Advent2020.Day do
  @callback part_one() :: any()
  @callback part_two() :: any()

  defmacro __using__([day: day]) do
    quote do
      @behaviour unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :day, persist: true)
      Module.put_attribute(__MODULE__, :day, unquote(day))

      alias Advent2020.Parser
    end
  end
end
