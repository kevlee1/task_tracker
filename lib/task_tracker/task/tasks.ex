defmodule TaskTracker.Task.Tasks do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completion, :boolean, default: false
    field :description, :string, default: ""
    field :time, :integer, default: 0
    field :title, :string
    field :userID, :integer

    timestamps()
  end

  @doc false
  def changeset(tasks, attrs) do
    tasks
    |> cast(attrs, [:title, :description, :userID, :time, :completion])
    |> validate_required([:title, :description, :userID, :time, :completion])
  end
end
