defmodule TimemanagerWeb.Team_userJSON do
  alias Timemanager.Team.Team_user

  @doc """
  Renders a list of team_users.
  """
  def index(%{team_users: team_users}) do
    %{data: for(team_user <- team_users, do: data(team_user))}
  end

  @doc """
  Renders a single team_user.
  """
  def show(%{team_user: team_user}) do
    %{data: data(team_user)}
  end

  defp data(%Team_user{} = team_user) do
    %{
      id: team_user.id,
      team_id: team_user.team_id,
      user_id: team_user.user_id
    }
  end

end
