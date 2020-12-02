defmodule Advent2020.Days.Day2Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day2
  alias Advent2020.Days.Day2.PasswordPolicy

  describe "valid_password?" do
    test "sample input" do
      assert valid_password?("abcde", %PasswordPolicy{num_one: 1, num_two: 3, letter: "a"})
      refute valid_password?("cdefg", %PasswordPolicy{num_one: 1, num_two: 3, letter: "b"})
      assert valid_password?("ccccccccc", %PasswordPolicy{num_one: 2, num_two: 9, letter: "c"})
    end

    test "real input" do
      assert part_one() == 422
    end
  end

  describe "valid_official_password?" do
    test "sample input" do
      assert valid_official_password?("abcde", %PasswordPolicy{
               num_one: 1,
               num_two: 3,
               letter: "a"
             })

      refute valid_official_password?("cdefg", %PasswordPolicy{
               num_one: 1,
               num_two: 3,
               letter: "b"
             })

      refute valid_official_password?("ccccccccc", %PasswordPolicy{
               num_one: 2,
               num_two: 9,
               letter: "c"
             })
    end

    test "real input" do
      assert part_two() == 451
    end
  end
end
