defmodule Timemanager.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:user, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:working_time, [:user_id])
  end
end
