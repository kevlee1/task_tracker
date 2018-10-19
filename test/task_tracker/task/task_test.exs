defmodule TaskTracker.TaskTest do
  use TaskTracker.DataCase

  alias TaskTracker.Task

  describe "tasks" do
    alias TaskTracker.Task.Tasks

    @valid_attrs %{completion: true, description: "some description", time: 42, title: "some title", userID: 42}
    @update_attrs %{completion: false, description: "some updated description", time: 43, title: "some updated title", userID: 43}
    @invalid_attrs %{completion: nil, description: nil, time: nil, title: nil, userID: nil}

    def tasks_fixture(attrs \\ %{}) do
      {:ok, tasks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Task.create_tasks()

      tasks
    end

    test "list_tasks/0 returns all tasks" do
      tasks = tasks_fixture()
      assert Task.list_tasks() == [tasks]
    end

    test "get_tasks!/1 returns the tasks with given id" do
      tasks = tasks_fixture()
      assert Task.get_tasks!(tasks.id) == tasks
    end

    test "create_tasks/1 with valid data creates a tasks" do
      assert {:ok, %Tasks{} = tasks} = Task.create_tasks(@valid_attrs)
      assert tasks.completion == true
      assert tasks.description == "some description"
      assert tasks.time == 42
      assert tasks.title == "some title"
      assert tasks.userID == 42
    end

    test "create_tasks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_tasks(@invalid_attrs)
    end

    test "update_tasks/2 with valid data updates the tasks" do
      tasks = tasks_fixture()
      assert {:ok, %Tasks{} = tasks} = Task.update_tasks(tasks, @update_attrs)

      
      assert tasks.completion == false
      assert tasks.description == "some updated description"
      assert tasks.time == 43
      assert tasks.title == "some updated title"
      assert tasks.userID == 43
    end

    test "update_tasks/2 with invalid data returns error changeset" do
      tasks = tasks_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_tasks(tasks, @invalid_attrs)
      assert tasks == Task.get_tasks!(tasks.id)
    end

    test "delete_tasks/1 deletes the tasks" do
      tasks = tasks_fixture()
      assert {:ok, %Tasks{}} = Task.delete_tasks(tasks)
      assert_raise Ecto.NoResultsError, fn -> Task.get_tasks!(tasks.id) end
    end

    test "change_tasks/1 returns a tasks changeset" do
      tasks = tasks_fixture()
      assert %Ecto.Changeset{} = Task.change_tasks(tasks)
    end
  end
end
