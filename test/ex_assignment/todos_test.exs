defmodule ExAssignment.TodosTest do
  use ExAssignment.DataCase
  import ExAssignment.TodosFixtures

  alias ExAssignment.Todos
  alias ExAssignment.Todos.Todo

  describe "todos" do
    @invalid_attrs %{done: nil, priority: nil, title: nil}

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{done: true, priority: 42, title: "some title"}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.done == true
      assert todo.priority == 42
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{done: false, priority: 43, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.done == false
      assert todo.priority == 43
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end

  describe "get_recommended/1" do
    test "when there are no todos available" do
      assert Todos.get_recommended() == nil
    end

    test "when there are only done todos" do
      # given
      _done_todo = todo_fixture(%{done: true})

      # then
      assert Todos.get_recommended() == nil
    end

    test "when there are multiple todos should only return open todo" do
      # given
      open_todo = todo_fixture(%{done: false})
      _done_todo = todo_fixture(%{done: true})

      # then
      assert Todos.get_recommended().id == open_todo.id
    end

    test "when there are multiple open todos should return with least priority number" do
      # given
      _open_todo_1 = todo_fixture(%{done: false, priority: 40})
      open_todo_2 = todo_fixture(%{done: false, priority: 20})

      # then
      assert Todos.get_recommended().id == open_todo_2.id
    end
  end

  describe "list_todos/1" do
    test "returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "returns all open todos" do
      open_todo = todo_fixture(%{done: false})
      _done_todo = todo_fixture(%{done: true})

      assert Todos.list_todos(:open) == [open_todo]
    end

    test "returns all done todos" do
      _open_todo = todo_fixture(%{done: false})
      done_todo = todo_fixture(%{done: true})

      assert Todos.list_todos(:done) == [done_todo]
    end

    test "returns all todos with ascending pritority order" do
      # given
      open_todo_1 = todo_fixture(%{done: false, priority: 20})
      open_todo_2 = todo_fixture(%{done: true, priority: 40})

      # when
      assert Todos.list_todos() == [open_todo_1, open_todo_2]
    end

    test "returns all todos when there is typo argument" do
      # given
      open_todo_1 = todo_fixture(%{done: false, priority: 20})
      open_todo_2 = todo_fixture(%{done: true, priority: 40})

      # when
      typo = :doen
      assert Todos.list_todos(typo) == [open_todo_1, open_todo_2]
    end
  end
end
