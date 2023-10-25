defmodule Timemanager.Repo.Migrations.CreateTeamUsers do
  use Ecto.Migration

  def change do
    create table(:team_users) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create index(:team_users, [:team_id])
    create index(:team_users, [:user_id])
  end
end
