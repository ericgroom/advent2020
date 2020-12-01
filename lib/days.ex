defmodule Advent2020.Days do
  def all_days do
    :application.get_key(:advent2020, :modules)
  end
end
