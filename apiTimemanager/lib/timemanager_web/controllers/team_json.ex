defmodule TimemanagerWeb.TeamJSON do
  alias Timemanager.Teams.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  @doc """
  Renders a list of teams link to a manager.
  """
  def render_team_link_manager(%{teams: teams}) do
    %{data: Enum.map(teams, &data/1)}
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name
    }
  end
end
