defmodule Advent2020.Days.Day8 do
  use Advent2020.Day, day: 8

  defmodule ExecutionContext do
    @type address() :: integer()
    @type op() :: :nop | :acc | :jmp
    @type instruction() :: {op(), integer()}
    @type t() :: %__MODULE__{
            memory: %{address() => instruction()},
            instruction_ptr: address(),
            accumulator: integer()
          }
    defstruct [:memory, :instruction_ptr, :accumulator]

    @spec new([instruction()]) :: t()
    def new(instructions) do
      memory =
        instructions
        |> Stream.with_index()
        |> Stream.map(fn {op, ptr} -> {ptr, op} end)
        |> Enum.into(%{})

      %__MODULE__{memory: memory, instruction_ptr: 0, accumulator: 0}
    end

    @spec get_head(t()) :: instruction()
    def get_head(%__MODULE__{memory: memory, instruction_ptr: instruction_ptr}),
      do: memory[instruction_ptr]

    def next(context), do: update_in(context.instruction_ptr, &(&1 + 1))
  end

  def part_one do
    @input
    |> parse()
    |> ExecutionContext.new()
    |> run_until_loop_detected()
  end

  def parse(raw) do
    raw
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(instruction) do
    [op, value] = String.split(instruction, " ")
    op = String.to_existing_atom(op)
    {value, ""} = Integer.parse(value)
    {op, value}
  end

  @spec run_until_loop_detected(ExecutionContext.t(), MapSet.t()) :: integer()
  def run_until_loop_detected(context, previous_instructions \\ MapSet.new()) do
    if MapSet.member?(previous_instructions, context.instruction_ptr) do
      context.accumulator
    else
      with_current = MapSet.put(previous_instructions, context.instruction_ptr)
      new_context = run_head(context)
      run_until_loop_detected(new_context, with_current)
    end
  end

  defp run_head(context) do
    instruction = ExecutionContext.get_head(context)

    case instruction do
      {:nop, _} ->
        ExecutionContext.next(context)

      {:acc, value} ->
        %ExecutionContext{
          memory: context.memory,
          instruction_ptr: context.instruction_ptr + 1,
          accumulator: context.accumulator + value
        }

      {:jmp, value} ->
        update_in(context.instruction_ptr, &(&1 + value))
    end
  end
end
