defmodule TaskTrackerWeb.TasksControllerTest do
  use TaskTrackerWeb.ConnCase

  alias TaskTracker.Task

  @create_attrs %{completion: true, description: "some description", time: 42, title: "some title", userID: 42}
  @update_attrs %{completion: false, description: "some updated description", time: 43, title: "some updated title", userID: 43}
  @invalid_attrs %{completion: nil, description: nil, time: nil, title: nil, userID: nil}

  def fixture(:tasks) do
    {:ok, tasks} = Task.create_tasks(@create_attrs)
    tasks
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.tasks_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tasks"
    end
  end

  describe "new tasks" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tasks_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tasks"
    end
  end

  describe "create tasks" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tasks_path(conn, :create), tasks: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tasks_path(conn, :show, id)

      conn = get(conn, Routes.tasks_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tasks"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tasks_path(conn, :create), tasks: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tasks"
    end
  end

  describe "edit tasks" do
    setup [:create_tasks]

    test "renders form for editing chosen tasks", %{conn: conn, tasks: tasks} do
      conn = get(conn, Routes.tasks_path(conn, :edit, tasks))
      assert html_response(conn, 200) =~ "Edit Tasks"
    end
  end

  describe "update tasks" do
    setup [:create_tasks]

    test "redirects when data is valid", %{conn: conn, tasks: tasks} do
      conn = put(conn, Routes.tasks_path(conn, :update, tasks), tasks: @update_attrs)
      assert redirected_to(conn) == Routes.tasks_path(conn, :show, tasks)

      conn = get(conn, Routes.tasks_path(conn, :show, tasks))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, tasks: tasks} do
      conn = put(conn, Routes.tasks_path(conn, :update, tasks), tasks: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tasks"
    end
  end

  describe "delete tasks" do
    setup [:create_tasks]

    test "deletes chosen tasks", %{conn: conn, tasks: tasks} do
      conn = delete(conn, Routes.tasks_path(conn, :delete, tasks))
      assert redirected_to(conn) == Routes.tasks_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.tasks_path(conn, :show, tasks))
      end
    end
  end

  defp create_tasks(_) do
    tasks = fixture(:tasks)
    {:ok, tasks: tasks}
  end
end
