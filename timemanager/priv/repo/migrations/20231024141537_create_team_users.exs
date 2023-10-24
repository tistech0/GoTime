defmodule Timemanager.Repo.Migrations.CreateTeamUsers do
  use Ecto.Migration

  def change do
    create table(:team_users) do
      add :team_id, references(:team, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:team_users, [:team_id])
    create index(:team_users, [:user_id])
  end
end
