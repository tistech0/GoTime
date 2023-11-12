defmodule TimemanagerWeb.Team_userController do
  use TimemanagerWeb, :controller

  alias Timemanager.Team
  alias Timemanager.Team.Team_user
  alias TimemanagerWeb.ErrorTemplate

  action_fallback TimemanagerWeb.FallbackController

  def create(conn, %{"team_user" => team_user_params}) do
    try do
      with {:ok, %Team_user{} = team_user} <- Team.create_team_user(team_user_params) do
        conn
        |> put_status(:created)
        |> render(:show, team_user: team_user)
      end
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error Parameters")
    end
  end

  def delete(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    try do
      team_user = Team.get_team_user_by_teamid_userid(team_id, user_id)

      with {:ok, %Team_user{}} <- Team.delete_team_user(team_user) do
        send_resp(conn, :no_content, "")
      end
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error Parameters")
    end
  end

  def getTeamLinkMember(conn, %{"userID" => id}) do
    try do
      team_user = Team.get_list_team_link_member(id)

      conn
      |> put_status(:ok)
      |> json(%{
        "teams" =>
          Enum.map(
            team_user,
            &%{
              "name" => &1.name
            }
          )
      })
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whit the user id")
    end
  end
end
