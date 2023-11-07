defmodule Timemanager.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field(:role, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
