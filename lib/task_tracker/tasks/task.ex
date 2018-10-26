defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completion, :boolean, default: false
    field :description, :string, default: ""
    field :time, :integer, default: 0
    field :title, :string
    field :userID, :id, default: 0
    belongs_to :user, TaskTracker.Users.User
    has_many :time_blocks, TaskTracker.TimeBlocks.TimeBlock

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:completion, :description, :time, :title, :user_id])
    |> validate_required([:completion, :description, :time, :title])
  end
end
