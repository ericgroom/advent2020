defmodule Advent2020.Day do
  @callback part_one() :: any()
  @callback part_two() :: any()

  defmacro __using__([day: day]) do
    quote do
      @behaviour unquote(__MODULE__)

      Module.put_attribute(__MODULE__, :day, unquote(day))
    end
  end
end
