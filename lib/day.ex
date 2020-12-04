defmodule Advent2020.Day do
  @callback part_one() :: any()
  @callback part_two() :: any()

  defmacro __using__(day: day) do
    quote do
      @behaviour unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :day, persist: true)
      Module.put_attribute(__MODULE__, :day, unquote(day))

      path = Path.join(Path.dirname(__ENV__.file), "day_#{unquote(day)}_input.txt")
      @external_resource path
      @input if File.exists?(path), do: File.read!(path)

      alias Advent2020.Parser
    end
  end
end
