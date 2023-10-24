defmodule Timemanager.TeamFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Team` context.
  """

  @doc """
  Generate a team_user.
  """
  def team_user_fixture(attrs \\ %{}) do
    {:ok, team_user} =
      attrs
      |> Enum.into(%{

      })
      |> Timemanager.Team.create_team_user()

    team_user
  end
end
