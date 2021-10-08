defmodule Processes.Stack do
  def new(initial_value \\ []) do
    spawn(__MODULE__, :run, [initial_value])
  end

  def run(state) do
    new_state =
      receive do
        {:get, from_pid} ->
          send(from_pid, {:get, state})
          state

        {:push, new_value} ->
          [new_value | state]
      end

    run(new_state)
  end
end
