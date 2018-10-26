defmodule TaskTracker.Repo.Migrations.CreateTimeBlock do
  use Ecto.Migration

  def change do
    create table(:time_block) do
      add :endTime, :utc_datetime
      add :startTime, :utc_datetime

      timestamps()
    end

  end
end
