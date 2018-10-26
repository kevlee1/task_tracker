defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        #|> redirect(to: Routes.task_path(conn, :show, task))
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    if (task.user_id == nil) do
      user_name = %{name: "Not assigned"}
      render(conn, "show.html", task: task, user: user_name)
    else
      user_name = TaskTracker.Users.get_user(task.user_id)
      render(conn, "show.html", task: task, user: user_name)
    end
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    current_user_id = conn.assigns[:current_user].id
    |> TaskTracker.Users.get_user!

    IO.inspect(task_params)

    IO.inspect(Integer.parse(task_params["user_id"]))
    
    if task_params["user_id"] == "" do
      case Tasks.update_task(task, task_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: Routes.task_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    else

    assignee_user = elem(Integer.parse(task_params["user_id"]), 0)
    |> TaskTracker.Users.get_user!

    #is_not_manager? = assignee_user.manager == nil or current_user_id.id != assignee_user.manager.id 

    cond do
      task.user_id == assignee_user.id ->
      case Tasks.update_task(task, task_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: Routes.task_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end

      assignee_user.manager == nil or current_user_id.id != assignee_user.manager.id ->
        put_flash(conn, :error, "You're not the manager of the new assignee. Only direct managers can assign tasks.")
        |> redirect(to: Routes.task_path(conn, :index))

      true ->
        case Tasks.update_task(task, task_params) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "Task updated successfully.")
            #|> redirect(to: Routes.task_path(conn, :show, task))
            |> redirect(to: Routes.task_path(conn, :index))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", task: task, changeset: changeset)
        end
    end
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
