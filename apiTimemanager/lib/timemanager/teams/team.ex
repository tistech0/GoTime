defmodule Timemanager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "teams" do
    field :name, :string
    belongs_to :user, Timemanager.Account.User, foreign_key: :manager_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name, :manager_id])
  end
end
