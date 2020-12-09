defmodule Advent2020.Days.Day8Test do
  use ExUnit.Case, async: true

  import Advent2020.Days.Day8
  alias Advent2020.VM.ExecutionContext

  @sample """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  describe "parse/1" do
    test "can parse sample input" do
      assert parse(@sample) == [
               {:nop, 0},
               {:acc, 1},
               {:jmp, 4},
               {:acc, 3},
               {:jmp, -3},
               {:acc, -99},
               {:acc, 1},
               {:jmp, -4},
               {:acc, 6}
             ]
    end
  end

  describe "ExecutionContext.new/1" do
    test "can transform parsed input" do
      input = parse(@sample)
      context = ExecutionContext.new(input)

      assert context.memory == %{
               0 => {:nop, 0},
               1 => {:acc, 1},
               2 => {:jmp, 4},
               3 => {:acc, 3},
               4 => {:jmp, -3},
               5 => {:acc, -99},
               6 => {:acc, 1},
               7 => {:jmp, -4},
               8 => {:acc, 6}
             }
    end
  end

  describe "run_until_loop_detected/1" do
    test "sample input" do
      instructions = parse(@sample)
      context = ExecutionContext.new(instructions)
      assert run_until_loop_detected(context) == 5
    end

    test "real input" do
      assert part_one() == 1859
    end
  end

  describe "run_with_corruption_correction/1" do
    test "sample input" do
      instructions = parse(@sample)
      context = ExecutionContext.new(instructions)
      assert run_with_corruption_correction(context) == 8
    end

    test "real input" do
      assert part_two() == 1235
    end
  end
end
