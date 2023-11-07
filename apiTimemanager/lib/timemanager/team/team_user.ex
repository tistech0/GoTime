defmodule Timemanager.Team.Team_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_users" do
    belongs_to :team, Timemanager.Teams.Team, foreign_key: :team_id
    belongs_to :user, Timemanager.Account.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
  end
end
