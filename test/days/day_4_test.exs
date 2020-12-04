defmodule Advent2020.Days.Day4Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day4

  describe "valid_north_pole_credentials?" do
    test "sample inputs" do
      assert valid_north_pole_credentials?(%{
               "ecl" => "gry",
               "pid" => "860033327",
               "eyr" => "2020",
               "hcl" => "#fffffd",
               "byr" => "1937",
               "iyr" => "2017",
               "cid" => "147",
               "hgt" => "183cm"
             })

      refute valid_north_pole_credentials?(%{
               "ecl" => "amb",
               "pid" => "028048884",
               "eyr" => "2023",
               "hcl" => "#cfa07d",
               "byr" => "1929",
               "iyr" => "2013",
               "cid" => "350"
             })

      assert valid_north_pole_credentials?(%{
               "ecl" => "brn",
               "pid" => "760753108",
               "eyr" => "2024",
               "hcl" => "#ae17e1",
               "byr" => "1931",
               "iyr" => "2013",
               "hgt" => "179cm"
             })

      refute valid_north_pole_credentials?(%{
               "ecl" => "brn",
               "pid" => "166559648",
               "eyr" => "2025",
               "hcl" => "#cfa07d",
               "iyr" => "2011",
               "hgt" => "59in"
             })
    end

    test "real input" do
      assert part_one == 250
    end
  end
end
