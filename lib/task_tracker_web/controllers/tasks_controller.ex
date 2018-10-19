defmodule TaskTrackerWeb.TasksController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Task
  alias TaskTracker.Task.Tasks

  def index(conn, _params) do
    tasks = Task.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Task.change_tasks(%Tasks{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tasks" => tasks_params}) do
    case Task.create_tasks(tasks_params) do
      {:ok, tasks} ->
        conn
        |> put_flash(:info, "Tasks created successfully.")
        |> redirect(to: Routes.tasks_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tasks = Task.get_tasks!(id)
    user_name = TaskTracker.Users.get_user(tasks.user)
    if (user_name == nil) do
      user_name = %{name: "Not Assigned"}
      render(conn, "show.html", tasks: tasks, user: user_name)
    else
      render(conn, "show.html", tasks: tasks, user: user_name)
    end
  end

  def edit(conn, %{"id" => id}) do
    tasks = Task.get_tasks!(id)
    changeset = Task.change_tasks(tasks)
    render(conn, "edit.html", tasks: tasks, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tasks" => tasks_params}) do
    tasks = Task.get_tasks!(id)
    if(rem(elem(Integer.parse(tasks_params["time"]), 0), 15) != 0) do
      put_flash(conn, :error, "Must increment by 15 minutes")
      |> redirect(to: Routes.tasks_path(conn, :index))
    else
      case Task.update_tasks(tasks, tasks_params) do
        {:ok, tasks} ->
          conn
          |> put_flash(:info, "Tasks updated successfully.")
          |> redirect(to: Routes.tasks_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", tasks: tasks, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    tasks = Task.get_tasks!(id)
    {:ok, _tasks} = Task.delete_tasks(tasks)

    conn
    |> put_flash(:info, "Tasks deleted successfully.")
    |> redirect(to: Routes.tasks_path(conn, :index))
  end
end
