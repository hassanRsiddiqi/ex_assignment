defmodule ExAssignment.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(title priority done)a
  @optional ~w()a

  schema "todos" do
    field(:done, :boolean, default: false)
    field(:priority, :integer)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
