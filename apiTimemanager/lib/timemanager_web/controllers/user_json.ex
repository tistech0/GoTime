defmodule TimemanagerWeb.UserJSON do
  alias Timemanager.Account.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end


  def show_profile(%{user: user}) do
    %{data: data_profile(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      time_contract: user.time_contract,
      role_id: user.role_id
    }
  end

  defp data_profile(%{
      id: _,
      username: _,
      email: _,
      time_contract: _,
      role: _
    } = user
  ) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      time_contract: user.time_contract,
      role: user.role
    }
  end
end
