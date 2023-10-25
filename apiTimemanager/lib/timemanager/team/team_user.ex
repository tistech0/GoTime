defmodule Timemanager.Team.Team_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_users" do

    field :team_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
