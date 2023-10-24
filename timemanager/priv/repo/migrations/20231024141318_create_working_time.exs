defmodule Timemanager.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create index(:working_time, [:user_id])
  end
end
