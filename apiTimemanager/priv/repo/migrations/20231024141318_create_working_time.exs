defmodule Timemanager.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :valueDay, :float, default: 0.0, null: false
      add :valueNight, :float, default: 0.0, null: false
      add :status, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create index(:working_time, [:user_id])

    execute(
      "ALTER TABLE working_time ADD CONSTRAINT valid_status CHECK (status = 'validated' OR status = 'waiting' OR status = 'refused')"
    )
  end
end
