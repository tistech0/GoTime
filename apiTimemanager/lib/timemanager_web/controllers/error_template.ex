defmodule TimemanagerWeb.ErrorTemplate do
  use TimemanagerWeb, :controller

  @doc """
    This private def is an error template to return.
    It accepts the conn, and HttpErrorCode and a message
  """
  def error_template(conn, error_code, message) do
    conn
    |> put_status(error_code)
    |> json(%{error: message})
    |> halt()
  end
end
