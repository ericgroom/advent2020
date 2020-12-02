defmodule Advent2020.Days.Day2Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day2
  alias Advent2020.Days.Day2.PasswordPolicy

  describe "valid_password?" do
    test "sample input" do
      assert valid_password?("abcde", %PasswordPolicy{min: 1, max: 3, letter: "a"})
      refute valid_password?("cdefg", %PasswordPolicy{min: 1, max: 3, letter: "b"})
      assert valid_password?("ccccccccc", %PasswordPolicy{min: 2, max: 9, letter: "c"})
    end

    test "real input" do
      assert part_one() == 422
    end
  end
end
