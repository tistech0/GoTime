defmodule Timemanager.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:time_contract, :integer)
    field(:username, :string)
    belongs_to(:role, Timemanager.Account.Role, foreign_key: :role_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract, :role_id])
    |> validate_required([:username, :email, :password, :time_contract, :role_id])
  end

  @doc false
  def get_user!(id) do
    Timemanager.Repo.get!(Timemanager.Account.User, id)
  end
end
