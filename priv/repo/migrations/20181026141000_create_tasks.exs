defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :text
      add :time, :integer
      add :title, :string
      add :userID, :integer
      add :completion, :boolean, default: false, null: false

      timestamps()
    end

    create index(:tasks, [:userID])
  end
end
