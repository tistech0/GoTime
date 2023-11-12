defmodule Timemanager.Team do
  @moduledoc """
  The Team context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Team.Team_user

  @doc """
  Returns the list of team_users.

  ## Examples

      iex> list_team_users()
      [%Team_user{}, ...]

  """
  def list_team_users do
    Repo.all(Team_user)
  end

  @doc """
  Gets a single team_user.

  Raises `Ecto.NoResultsError` if the Team user does not exist.

  ## Examples

      iex> get_team_user!(123)
      %Team_user{}

      iex> get_team_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_user!(id), do: Repo.get!(Team_user, id)

  @doc """
  Creates a team_user.

  ## Examples

      iex> create_team_user(%{field: value})
      {:ok, %Team_user{}}

      iex> create_team_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_user(attrs \\ %{}) do
    %Team_user{}
    |> Team_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_user.

  ## Examples

      iex> update_team_user(team_user, %{field: new_value})
      {:ok, %Team_user{}}

      iex> update_team_user(team_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_user(%Team_user{} = team_user, attrs) do
    team_user
    |> Team_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_user.

  ## Examples

      iex> delete_team_user(team_user)
      {:ok, %Team_user{}}

      iex> delete_team_user(team_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_user(%Team_user{} = team_user) do
    Repo.delete(team_user)
  end

  @doc """
    This def removes the user from all teams
  """
  def delete_team_user_by_user_id(user_id) do
    team_users = from(tu in Team_user, where: tu.user_id == ^user_id)
    Repo.delete_all(team_users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_user changes.

  ## Examples

      iex> change_team_user(team_user)
      %Ecto.Changeset{data: %Team_user{}}

  """
  def change_team_user(%Team_user{} = team_user, attrs \\ %{}) do
    Team_user.changeset(team_user, attrs)
  end

  @doc """
  Get all teams linked to a user_id.

  ## Examples

      iex> get_list_team_link_manager(user_id)
      [%Team_user{}, ...]

  """
  def get_list_team_link_member(user_id) do
    # Query to retrieve all teams associated with the user
    query =
      from(tu in Timemanager.Team.Team_user,
        where: tu.user_id == ^user_id,
        join: t in Timemanager.Teams.Team,
        on: t.id == tu.team_id,
        select: t
      )

    Repo.all(query)
  end

  def get_team_user_by_teamid_userid(team_id, user_id) do
    from(tu in Timemanager.Team.Team_user,
      where: tu.user_id == ^user_id and tu.team_id == ^team_id,
      select: tu
    )
    |> Repo.one()
  end
end
