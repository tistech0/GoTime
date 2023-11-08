defmodule Timemanager.Repo.Migrations.CreateTeamUsers do
  use Ecto.Migration

  def change do
    create table(:team_users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :team_id, references(:teams, type: :uuid, on_delete: :nothing)
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create(index(:team_users, [:team_id]))
    create(index(:team_users, [:user_id]))
  end
end
