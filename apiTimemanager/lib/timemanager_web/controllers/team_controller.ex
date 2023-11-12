defmodule TimemanagerWeb.TeamController do
  use TimemanagerWeb, :controller

  alias Timemanager.Teams
  alias Timemanager.Teams.Team
  alias TimemanagerWeb.ErrorTemplate

  action_fallback(TimemanagerWeb.FallbackController)

  def index(conn, _params) do
    try do
      teams = Teams.list_teams()
      render(conn, :index, teams: teams)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error API")
    end
  end

  def create(conn, %{"team" => team_params}) do
    try do
      with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
        conn
        |> put_status(:created)
        |> render(:show, team: team)
      end
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error Parameters")
    end
  end

  def show(conn, %{"teamID" => id}) do
    try do
      team = Teams.get_team!(id)
      render(conn, :show, team: team)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the team id")
    end
  end

  def update(conn, %{"teamID" => id, "team" => team_params}) do
    try do
      team = Teams.get_team!(id)

      with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
        render(conn, :show, team: team)
      end
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the team id or the parameters")
    end
  end


  def delete(conn, %{"teamID" => id}) do
    try do
      team = Teams.get_team!(id)
        with {:ok, %Team{}} <- Teams.delete_team(team) do
          send_resp(conn, :no_content, "")
        end
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the team id")
      end
  end

  @doc """
    This def gets the team the user given in parameter manages.
    This def is only accessible for the superadmin as he can see all teams.
  """
  def getTeamLinkManager(conn, %{"userID" => id}) do
    try do
      teams = Teams.get_list_team_link_manager(id)
      render(conn, :render_team_link_manager, teams: teams)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the user id")
    end
  end

  @doc """
    This def gets the team the current user manages.
  """
  def get_Team_Current_User_Manager(conn, _params) do
    try do
      current_user = conn.assigns[:current_user]
      teams = Teams.get_list_team_link_manager(current_user.id)
      render(conn, :render_team_link_manager, teams: teams)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the user id")
    end
  end
end
