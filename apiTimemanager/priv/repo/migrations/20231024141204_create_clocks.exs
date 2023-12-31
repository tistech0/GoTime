defmodule Timemanager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :time, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create(index(:clocks, [:user_id]))
  end
end
