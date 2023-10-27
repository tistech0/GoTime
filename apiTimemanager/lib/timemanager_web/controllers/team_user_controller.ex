defmodule TimemanagerWeb.Team_userController do
  use TimemanagerWeb, :controller

  alias Timemanager.Team
  alias Timemanager.Team.Team_user

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    team_users = Team.list_team_users()
    render(conn, :index, team_users: team_users)
  end

  def create(conn, %{"team_user" => team_user_params}) do
    with {:ok, %Team_user{} = team_user} <- Team.create_team_user(team_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/team_users/#{team_user}")
      |> render(:show, team_user: team_user)
    end
  end

  def show(conn, %{"id" => id}) do
    team_user = Team.get_team_user!(id)
    render(conn, :show, team_user: team_user)
  end

  def update(conn, %{"id" => id, "team_user" => team_user_params}) do
    team_user = Team.get_team_user!(id)

    with {:ok, %Team_user{} = team_user} <- Team.update_team_user(team_user, team_user_params) do
      render(conn, :show, team_user: team_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_user = Team.get_team_user!(id)

    with {:ok, %Team_user{}} <- Team.delete_team_user(team_user) do
      send_resp(conn, :no_content, "")
    end
  end

  def getTeamLinkMember(conn, %{"userID" => id}) do
    team_user = Team.get_list_team_link_member(id)

    conn
    |> put_status(:ok)
    |> json(%{
      "teams" => Enum.map(team_user, &%{
        "name" => &1.name
      })
    })
  end
end
