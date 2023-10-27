defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Account
  alias Timemanager.Account.User
  alias TimemanagerWeb.UserAuth
  alias Timemanager.Roles

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
  @todo "Check if user can create another user. NB with role different than User"
  def register(conn, %{"user" => user_params}) do

    # Chek if the current user's role to control the action
    current_user_role = Roles.get_role!(conn.assigns[:current_user].role_id).role
    role = cond do
      current_user_role == "Admin" -> # Can only create users with the "User" role
        Roles.get_role_by_role("User")
      current_user_role == "SuperAdmin" -> # Can create users with any role
        Roles.get_role_by_role(user_params["role"])
      true -> # Can't create any user by default
        conn
        |> put_status(401)
        |> json(%{error: "You are not allowed to create a new user."})
        |> halt()
    end

    # Send an error if the role given doesn't exist.
    if is_nil(role) do
      conn
      |> put_status(400)
      |> json(%{error: "Invalid role."})
      |> halt()
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
        json(conn |> put_status(403), %{error: error_msg})
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
      # Send message
      json(conn |> put_status(404), %{error: "Email and username are different"})
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
      conn
      |> put_status(401)
      |> json(%{error: "You can't update this user."})
      |> halt()
    end
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc """
    This def delete the user.
  """
  @todo "Need to delete userId references"
  def delete(conn, %{"userID" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
