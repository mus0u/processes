defmodule Processes.StackTest do
  use ExUnit.Case

  alias Processes.Stack

  # (in milliseconds)
  @one_second 1_000

  test "make a new stack" do
    my_stack = Stack.new([1, 2, 3, 4, 5])

    send(my_stack, {:get, self()})

    response =
      receive do
        {:get, value} -> value
      after
        @one_second -> flunk("no response received")
      end

    assert response == [1, 2, 3, 4, 5]
  end

  test "pushing a value onto the stack" do
    my_stack = Stack.new()

    send(my_stack, {:push, 1})

    send(my_stack, {:get, self()})

    response =
      receive do
        {:get, value} -> value
      after
        @one_second -> flunk("no response received")
      end

    assert response == [1]
  end

  @tag :skip
  test "popping a value off of the stack" do
    my_stack = Stack.new([1, 2, 3, 4, 5])

    send(my_stack, {:pop, self()})

    result =
      receive do
        {:pop, value} -> value
      after
        @one_second -> flunk("no response received")
      end

    assert result == 1

    send(my_stack, {:get, self()})

    remaining_stack =
      receive do
        {:get, value} -> value
      after
        @one_second -> flunk("no response received")
      end

    assert remaining_stack == [2, 3, 4, 5]
  end
end
