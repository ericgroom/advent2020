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

    @spec get_head(t()) :: instruction() | nil
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

  def part_two do
    context =
      @input
      |> parse()
      |> ExecutionContext.new()

    run_with_corruption_correction(context, context)
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

  @spec run_with_corruption_correction(ExecutionContext.t(), ExecutionContext.t(), List.t()) ::
          integer()
  def run_with_corruption_correction(context, og, previous_instructions \\ []) do
    if Enum.member?(previous_instructions, context.instruction_ptr) do

      previous_occurrence =
        Enum.find_index(previous_instructions, fn ptr -> ptr == context.instruction_ptr end)

      cycle = Enum.slice(previous_instructions, 0..previous_occurrence)
      culprits = corruptions_culprits(context, cycle)

      try do
        for ptr <- culprits do
          new_context = repair_corruption(og, ptr)

          case run_until_completion(new_context) do
            :cycle ->
              nil

            {:completed, acc} ->
              throw(acc)
          end
        end
      catch
        x -> x
      end
    else
      with_current = [context.instruction_ptr | previous_instructions]
      new_context = run_head(context)
      run_with_corruption_correction(new_context, og, with_current)
    end
  end

  defp corruptions_culprits(context, cycle) do
    cycle
    |> Enum.filter(fn ptr ->
      case context.memory[ptr] do
        {:nop, _value} ->
          true

        {:jmp, _value} ->
          true

        _ ->
          false
      end
    end)
  end

  defp repair_corruption(context, corrupted_at) do
    case context.memory[corrupted_at] do
      {:jmp, value} ->
        put_in(context.memory[corrupted_at], {:nop, value})

      {:nop, value} ->
        put_in(context.memory[corrupted_at], {:jmp, value})

      {:acc, _} ->
        raise "instructions state this is not the corrupted instruction"

      nil ->
        raise "cannot uncorrupt memory which does not exist"
    end
  end

  defp run_until_completion(context, previous_instructions \\ MapSet.new()) do
    current_ptr = context.instruction_ptr

    if MapSet.member?(previous_instructions, current_ptr) do
      :cycle
    else
      with_current = MapSet.put(previous_instructions, current_ptr)

      case run_head(context) do
        {:completed, acc} ->
          {:completed, acc}

        context ->
          run_until_completion(context, with_current)
      end
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

      nil ->
        {:completed, context.accumulator}
    end
  end
end
