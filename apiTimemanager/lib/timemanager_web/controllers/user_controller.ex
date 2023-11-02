defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Account
  alias Timemanager.Account.User
  alias Timemanager.Roles
  alias Timemanager.Time
  alias Timemanager.Team
  alias Timemanager.Teams

  @super_admin_role "SuperAdmin"
  @admin_role "Admin"
  @user_role "User"

  action_fallback TimemanagerWeb.FallbackController

  @doc """
    This def gets the list of users
  """
  @todo "Check if user can access this information"
  def index(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  @doc """
  This def creates a new user with the User default role
  """
  def register(conn, %{"user" => user_params}) do

    # Chek if the current user's role to control the action
    current_user_role = Roles.get_role!(conn.assigns[:current_user].role_id).role
    role = cond do
      current_user_role == @super_admin_role -> # Can create users with any role
        Roles.get_role_by_role(user_params["role"])
      true -> # Admin can only create users with the @user_role role
        Roles.get_role_by_role(@user_role)
    end

    # Send an error if the role given doesn't exist.
    if is_nil(role) do
      error_template(conn, 400, "Invalid role")
    end

    # Assign the role id to the user
    user_params_with_role = Map.put(user_params, "role_id", role.id)

    case Account.register_user(user_params_with_role) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:show, user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        error_msg = changeset_error_message(changeset)
        error_template(conn, 403, error_msg)
      end
  end

  @doc """
    This defp is used to extract the error message from the changeset.
  """
  defp changeset_error_message(%Ecto.Changeset{errors: errors}) do
    errors
    |> Enum.map(fn {field, {message, _values}} -> "#{field} #{message}" end)
    |> Enum.join(", ")
  end

  @doc """
    This def gets the user by its id
  """
  @todo "Check if user can access this information"
  def show(conn, %{"userID" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  @doc """
    This def gets a user by its email and username
  """
  @todo "Check if user can access this information"
  def get_user_by_email_and_username(conn, %{"email" => email, "username" => username}) do
    if user = Account.get_user_by_email_and_username(email, username) do
      render(conn, :show, user: user)
    else
      error_template(conn, 404, "Email and username are different.")
    end
  end

  @doc """
    This def updates the user.
    If the id provided is diferent than the id of the current user, throw an error
  """
  def update(conn, %{"userID" => id, "user" => user_params}) do

    # check that the user connected is the user it is trying to update
    current_user_id = conn.assigns[:current_user].id
    if current_user_id != String.to_integer(id) do
      error_template(conn, 401, "You are not allowed to update this user.")
    end
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc """
    This def updates only the user role. It will only work for a SuperAdmin
  """
  def update_user_role(conn, %{"userID" => id, "role" => role}) do

    # check that the user connected is a @super_admin_role
    current_user_role = Roles.get_role!(conn.assigns[:current_user].role_id).role
    if current_user_role != @super_admin_role do
      error_template(conn, 401, "You are not allowed to update this user's role.")
    end
    user = Account.get_user!(id)

    new_role = Roles.get_role_by_role(role)

    # Send an error if the role given doesn't exist.
    if is_nil(new_role) do
      error_template(conn, 400, "Invalid role")
    end

    with {:ok, %User{} = user} <- Account.update_user_role(user, %{role_id: new_role.id}) do
      render(conn, :show, user: user)
    end
  end

  @doc """
    This def delete the user.
  """
  def delete(conn, %{"userID" => id}) do
    current_user = conn.assigns[:current_user]

    # fetch the user to delete
    user = Account.get_user(id)

    # Check user isn't nil
    if is_nil(user) do
      error_template(conn, 400, "Invalid user")
    end

    # Check user isn't trying to delete itself
    if current_user.id == user.id do
      error_template(conn, 403, "You are no allowed to delete yourself")
    end

    # If the user has the @user_role, terminate the def
    if Roles.get_role!(user.role_id).role != @user_role do
      # get user's managed team
      teams_managed = Teams.get_list_team_link_manager(user.id)
      # if list isn't empty, send error because the user is manages at least one team. Manager should be replaced before deleting
      if teams_managed != [] do
        error_template(conn, 403, "The user manages teams. You should replace the manager before deleting this user.")
      end
    end

    # delete all clocks for this user
    Time.delete_all_clocks_by_user_id(user.id)

    # delete all working times for this user
    Time.delete_all_working_times_by_user_id(user.id)

    # user_token should delete themselves because of cascade delete

    # remove user from team_user
    Team.delete_team_user_by_user_id(user.id)

    # finally delete the user
    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
    This private def is an error template to return.
    It accepts the conn, and HttpErrorCode and a message
  """
  defp error_template(conn, error_code, message) do
    conn
    |> put_status(error_code)
    |> json(%{error: message})
    |> halt()
  end
end
