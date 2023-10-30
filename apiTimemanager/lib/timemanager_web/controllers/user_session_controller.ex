defmodule TimemanagerWeb.UserSessionController do
  use TimemanagerWeb, :controller

  alias Timemanager.Account
  alias TimemanagerWeb.UserAuth

  @doc """
    This def logs in the user by calling the Log_in_user function from the Account.
    It will create the token and insert it in the new session.
  """
  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Account.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      json(conn |> put_status(400), %{error: "Invalid email or password."})
    end
  end

  @doc """
    This def logs out the user by calling the Log_out_user function from the Account.
    It will delete the session and the token stored in the database.
  """
  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
