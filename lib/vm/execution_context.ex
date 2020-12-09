defmodule Advent2020.VM.ExecutionContext do
  alias __MODULE__

  @type address() :: integer()
  @type op() :: :nop | :acc | :jmp
  @type instruction() :: {op(), integer()}
  @type t() :: %ExecutionContext{
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

    %ExecutionContext{memory: memory, instruction_ptr: 0, accumulator: 0}
  end

  @spec get_head(t()) :: instruction() | nil
  def get_head(%ExecutionContext{memory: memory, instruction_ptr: instruction_ptr}),
    do: memory[instruction_ptr]

  @spec next(t()) :: t()
  def next(context), do: update_in(context.instruction_ptr, &(&1 + 1))

  @spec reset(t()) :: t()
  def reset(context),
    do: %ExecutionContext{memory: context.memory, instruction_ptr: 0, accumulator: 0}
end
