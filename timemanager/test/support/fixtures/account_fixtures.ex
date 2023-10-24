defmodule Timemanager.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password",
        time_contract: 42,
        username: "some username"
      })
      |> Timemanager.Account.create_user()

    user
  end
end
