defmodule TimemanagerWeb.RoleController do
  use TimemanagerWeb, :controller

  alias Timemanager.Roles
  alias Timemanager.Roles.Role

  require RoleEnum

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    roles = Roles.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Roles.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/roles/#{role}")
      |> render(:show, role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{} = role} <- Roles.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{}} <- Roles.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
    This def gets the list of possible roles depending on the current user roles. We only want the superAdmin to be able to see all roles.
  """
  def get_roles_list_for_current_user(conn, _params) do
    current_user_role = Roles.get_role!(conn.assigns[:current_user].role_id).role

    roles =
      if RoleEnum.role(:super_admin_role) == current_user_role do
        Roles.list_roles()
      else
        [Roles.get_role_by_role(RoleEnum.role(:user_role))]
      end

    render(conn, :index, roles: roles)
  end
end
