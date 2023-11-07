defmodule Timemanager.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :manager_id, references(:users, type: :uuid, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create index(:teams, [:manager_id])
  end
end
