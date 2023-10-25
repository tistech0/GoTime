defmodule Timemanager.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :time_contract, :integer
    field :username, :string
    field :role, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract])
    |> validate_required([:username, :email, :password, :time_contract])
  end
end
