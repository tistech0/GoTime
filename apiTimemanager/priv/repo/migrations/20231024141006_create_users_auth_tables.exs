defmodule Timemanager.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "")

    create table(:users) do
      add(:username, :string)
      add(:time_contract, :float)
      add(:role_id, references(:roles, on_delete: :nothing))
      add(:email, :citext, null: false)
      add(:hashed_password, :string, null: false)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
      add(:updated_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create(index(:users, [:role_id]))
    create(unique_index(:users, [:email]))

    create table(:users_tokens) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:token, :binary, null: false)
      add(:context, :string, null: false)
      add(:sent_to, :string)

      add(:inserted_at, :utc_datetime, default: fragment("now()"), null: false)
    end

    create(index(:users_tokens, [:user_id]))
    create(unique_index(:users_tokens, [:context, :token]))
  end
end
