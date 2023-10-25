defmodule Timemanager.RolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Roles` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        role: "some role"
      })
      |> Timemanager.Roles.create_role()

    role
  end
end
