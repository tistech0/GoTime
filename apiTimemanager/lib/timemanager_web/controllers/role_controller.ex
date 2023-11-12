defmodule TimemanagerWeb.RoleController do
  use TimemanagerWeb, :controller

  alias Timemanager.Roles
  alias TimemanagerWeb.ErrorTemplate

  require RoleEnum

  action_fallback TimemanagerWeb.FallbackController

  @doc """
    This def gets the list of possible roles depending on the current user roles. We only want the superAdmin to be able to see all roles.
  """
  def get_roles_list_for_current_user(conn, _params) do
    try do
      current_user_role = Roles.get_role!(conn.assigns[:current_user].role_id).role

      roles =
        if RoleEnum.role(:super_admin_role) == current_user_role do
          Roles.list_roles()
        else
          [Roles.get_role_by_role(RoleEnum.role(:user_role))]
        end

      render(conn, :index, roles: roles)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whith the current user")
    end
  end
end
