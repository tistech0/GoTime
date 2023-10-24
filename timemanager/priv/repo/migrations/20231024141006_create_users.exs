defmodule Timemanager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:email, :string)
      add(:password, :string)
      add(:time_contract, :integer)
      add(:role_id, references(:role, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:users, [:role_id]))
  end
end
