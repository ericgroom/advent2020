defmodule Advent2020.Math.TwoSum do
  import Inline

  test two_sum?([35, 20, 15, 25, 47], 40), is: true
  test two_sum?([182, 150, 117, 102, 95], 127), is: false

  def two_sum?(values, target) do
    Enum.any?(values, fn v ->
      counterpart = target - v
      Enum.member?(values, counterpart)
    end)
  end
end
