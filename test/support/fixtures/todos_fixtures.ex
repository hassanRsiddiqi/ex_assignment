defmodule ExAssignment.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExAssignment.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        done: true,
        priority: Enum.random(1..100),
        title: Faker.Lorem.Shakespeare.as_you_like_it()
      })
      |> ExAssignment.Todos.create_todo()

    todo
  end
end
