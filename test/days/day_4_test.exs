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
      assert part_one() == 250
    end
  end

  describe "valid_key_value/2" do
    test "sample inputs" do
      assert valid_key_value?("byr", "2002")
      refute valid_key_value?("byr", "2003")

      assert valid_key_value?("hgt", "60in")
      assert valid_key_value?("hgt", "190cm")
      refute valid_key_value?("hgt", "190in")
      refute valid_key_value?("hgt", "190")

      assert valid_key_value?("hcl", "#123abc")
      refute valid_key_value?("hcl", "#123abz")
      refute valid_key_value?("hcl", "123abc")

      assert valid_key_value?("ecl", "brn")
      refute valid_key_value?("ecl", "wat")

      assert valid_key_value?("pid", "000000001")
      refute valid_key_value?("pid", "0123456789")
    end
  end

  describe "valid_values?/1" do
    test "sample inputs" do
      assert valid_values?(%{
               "ecl" => "grn",
               "pid" => "087499704",
               "eyr" => "2030",
               "hcl" => "#623a2f",
               "byr" => "1980",
               "iyr" => "2012",
               "hgt" => "74in"
             })

      refute valid_values?(%{
               "ecl" => "amb",
               "pid" => "186cm",
               "eyr" => "1972",
               "hcl" => "#18171d",
               "byr" => "1926",
               "iyr" => "2018",
               "hgt" => "170"
             })
    end

    test "real input" do
      assert part_two() == 158
    end
  end
end
