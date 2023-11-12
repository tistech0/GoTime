defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Account
  alias Timemanager.Account.User
  alias Timemanager.Roles
  alias Timemanager.Time
  alias Timemanager.Team
  alias Timemanager.Teams

  require RoleEnum

  action_fallback(TimemanagerWeb.FallbackController)

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
  def register(conn, %{"user" => user_params, "team" => team_params}) do
    current_user = conn.assigns[:current_user]

    # Chek if the current user's role to control the action
    current_user_role = Roles.get_role!(current_user.role_id).role

    role =
      cond do
        # Can create users with any role
        current_user_role == RoleEnum.role(:super_admin_role) ->
          Roles.get_role(user_params["role_id"])

        # Admin can only create users with the User role
        true ->
          Roles.get_role_by_role(RoleEnum.role(:user_role))
      end

    # Send an error if the role given doesn't exist.
    if is_nil(role) do
      error_template(conn, 400, "Invalid role")
    end

    case Account.register_user(user_params) do
      {:ok, user} ->
        team_id = team_params["id"]

        if !is_nil(team_id) and team_id != "" do
          # Add user to team once the user is inserted
          add_user_to_team(team_id, current_user_role, user.id, current_user.id)
        end

        conn
        |> put_status(:created)
        |> render(:show, user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        error_msg = changeset_error_message(changeset)
        error_template(conn, 400, error_msg)
    end
  end

  # This defp is used to extract the error message from the changeset.
  defp changeset_error_message(%Ecto.Changeset{errors: errors}) do
    errors
    |> Enum.map(fn {field, {message, _values}} -> "#{field} #{message}" end)
    |> Enum.join(", ")
  end

  defp add_user_to_team(team_id, role, user_id, current_user_id) do
    if role == RoleEnum.role(:super_admin_role) do
      # Add user to the team as a super admin, so it could be any team as long as it exists
      team = Teams.get_team(team_id)

      if !is_nil(team) do
        team_to_create = %{
          team_id: team.id,
          user_id: user_id
        }

        Team.create_team_user(team_to_create)
      end
    else
      # Add user to the team as an admin so it can only be a managed team
      team = Teams.get_team(team_id)

      if !is_nil(team) and team.manager_id == current_user_id do
        team_to_create = %{
          team_id: team.id,
          user_id: user_id
        }

        Team.create_team_user(team_to_create)
      end
    end
  end

  @doc """
    This def gets the user by its id.
    Need to ckeck the role in order to adress the response accordingly.
    If user role, render the user profile.
    If admin role, render his profile or the profile of a user he manages.
    If super admin, render any user.
  """
  def show(conn, %{"userID" => user_id}) do
    # Check the current connected user and its role
    current_user = conn.assigns[:current_user]
    current_user_role = Roles.get_role(current_user.role_id)

    # This returns the current user if it's the same id. It will be the use case for the user role
    if user_id == current_user.id do
      user_with_role = Map.put(current_user, :role, current_user_role.role)
      render(conn, :show_profile, user: user_with_role)
    end

    # from here, if user send error
    if current_user_role.role == RoleEnum.role(:user_role) do
      error_template(conn, 403, "You are unauthorized to access this user.")
    end

    # If we reach this state, the user being accessed isn't the current user.

    case Account.get_user(user_id) do
      %User{} = user ->
        # Check is user is part of admin team
      if current_user_role.role == RoleEnum.role(:admin_role) do
        check_user_in_manager_team(conn, user.id, current_user.id)
      end

      role = Roles.get_role(user.role_id)
      user_with_role = Map.put(user, :role, role.role)

      render(conn, :show_profile, user: user_with_role)
    true -> # If no user found, send error.
      error_template(conn, 400, "You are unauthorized to update this user.")
    end
  end

  defp check_user_in_manager_team(conn, user_id, current_user_id) do
    # Get list of team_users with which the user is affiliated
    team_user_list = Team.get_list_team_link_member(user_id)
    # Check if the current_user is a manager
    is_team_manager = Enum.reduce(team_user_list, false, fn team_user, acc ->
      team = Teams.get_team(team_user.id)
      if team.manager_id == current_user_id do
        true
      else
        acc
      end
    end)
    if is_team_manager == false do
      error_template(conn, 400, "You are unauthorized to access this user.")
    end
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
  def update(conn, %{"userID" => user_id, "user" => user_params}) do

    current_user = conn.assigns[:current_user]
    current_user_role = Roles.get_role(current_user.role_id)

    with %User{} = user <- Account.get_user(user_id),
      {:ok, updated_user} <- handle_update(conn, current_user_role, current_user, user, user_params) do

      # Assign role value
      role = Roles.get_role(updated_user.role_id)
      updated_user_with_role = Map.put(updated_user, :role, role.role)

      render(conn, :show_profile, user: updated_user_with_role)
    else
      {:error, reason} ->
      error_template(conn, 400, reason)
    end
  end

  defp handle_update(conn, current_user_role, current_user, user, user_params) do
    case current_user_role.role do
      RoleEnum.role(:super_admin_role) ->
        Account.update_user_total(user, user_params)

      _ when user.id == current_user.id ->
        Account.update_current_user(user, user_params)

      RoleEnum.role(:admin_role) ->
        check_user_in_manager_team(conn, user.id, current_user.id)
        Account.update_other_user(user, user_params)

      _ ->
        {:error, "You are unauthorized to update this user."}
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
      error_template(conn, 400, "You are no allowed to delete yourself")
    end

    # If the user has the User role, terminate the def
    if Roles.get_role!(user.role_id).role != RoleEnum.role(:user_role) do
      # get user's managed team
      teams_managed = Teams.get_list_team_link_manager(user.id)

      # if list isn't empty, send error because the user is manages at least one team. Manager should be replaced before deleting
      if teams_managed != [] do
        error_template(
          conn,
          400,
          "The user manages teams. You should replace the manager before deleting this user."
        )
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
    This def gets the list of admins
  """
  def get_admins(conn, _params) do
    admins = Account.get_admins()
    render(conn, :index, users: admins)
  end

  #    This private def is an error template to return.
  #    It accepts the conn, and HttpErrorCode and a message

  defp error_template(conn, error_code, message) do
    conn
    |> put_status(error_code)
    |> json(%{error: message})
    |> halt()
  end
end
