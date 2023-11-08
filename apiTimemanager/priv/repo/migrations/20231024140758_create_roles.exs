defmodule Timemanager.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add(:role, :string, default: "User", null: false)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    execute(
      "ALTER TABLE roles ADD CONSTRAINT valid_roles CHECK (role = 'User' OR role = 'Admin' OR role = 'SuperAdmin')"
    )
  end
end
