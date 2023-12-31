defmodule Timemanager.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Time.WorkingTimes

  alias Timemanager.Time.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Gets a single clock with user id.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock_by_user_id!(user_id) do
    Repo.get_by(Clock, user_id: user_id)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}, user_id) do
    %Clock{}
    |> Clock.changeset(attrs, user_id)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def delete_all_clocks_by_user_id(user_id) do
    clocks = from(c in Clock, where: c.user_id == ^user_id)
    Repo.delete_all(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  @doc """
  Returns the list of working_time.

  ## Examples

      iex> list_working_time()
      [%WorkingTimes{}, ...]

  """
  def list_working_time do
    Repo.all(WorkingTimes)
  end

  @doc """
  Gets a single working_times.

  Raises `Ecto.NoResultsError` if the Working times does not exist.

  ## Examples

      iex> get_working_times!(123)
      %WorkingTimes{}

      iex> get_working_times!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_times!(id), do: Repo.get!(WorkingTimes, id)

  @doc """
  Get a single working_times link to workingTime id and UserId.

  """

  def get_working_times_by_user_id_and_working_time_id(user_id, working_time_id) do
    Repo.get_by(WorkingTimes, user_id: user_id, id: working_time_id)
  end

  @doc """
  Get a single working_times with user id with start and end time param.

  """

  def get_working_times_by_user_id_and_start_and_end_time(user_id, start_time, end_time) do
    query =
      from w in WorkingTimes,
        where: w.user_id == ^user_id and w.start >= ^start_time and w.end <= ^end_time

    Repo.all(query)
  end

  @doc """
  Creates a working_times.

  ## Examples

      iex> create_working_times(%{field: value})
      {:ok, %WorkingTimes{}}

      iex> create_working_times(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_times(attrs \\ %{}, user_id) do
    %WorkingTimes{}
    |> WorkingTimes.changeset(attrs, user_id)
    |> Repo.insert()
  end

  @doc """
  Updates a working_times.

  ## Examples

      iex> update_working_times(working_times, %{field: new_value})
      {:ok, %WorkingTimes{}}

      iex> update_working_times(working_times, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_times(%WorkingTimes{} = working_times, attrs) do
    working_times
    |> WorkingTimes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_times.

  ## Examples

      iex> delete_working_times(working_times)
      {:ok, %WorkingTimes{}}

      iex> delete_working_times(working_times)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_times(%WorkingTimes{} = working_times) do
    Repo.delete(working_times)
  end

  def delete_all_working_times_by_user_id(user_id) do
    working_times = from(wt in WorkingTimes, where: wt.user_id == ^user_id)
    Repo.delete_all(working_times)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_times changes.

  ## Examples

      iex> change_working_times(working_times)
      %Ecto.Changeset{data: %WorkingTimes{}}

  """
  def change_working_times(%WorkingTimes{} = working_times, attrs \\ %{}) do
    WorkingTimes.changeset(working_times, attrs)
  end

  @doc """
  Get all user linked to a team_id.

  ## Examples

      iex> get_list_team_link_manager(team_id)
      [%Team_user{}, ...]

  """
  def get_list_user_link_team(team_id) do
    query =
      from(tu in Timemanager.Team.Team_user,
        where: tu.team_id == ^team_id,
        join: u in Timemanager.Account.User,
        on: u.id == tu.user_id,
        select: u
      )

    Repo.all(query)
  end

  @doc """
  Get hours and minutes between two dates.
  ## Examples

      iex> calculate_day_and_night_hours(date1, date2)
      {day_hours, night_hours}

  """
  def calculate_day_and_night_hours(date1, date2) do
    total_diff = NaiveDateTime.diff(date2, date1, :minute)

    night_minutes = calculate_night_hours(date1, date2)
    day_minutes = total_diff - night_minutes

    {convert_to_hours(day_minutes), convert_to_hours(night_minutes)}
  end

  defp calculate_night_hours(from_datetime, to_datetime) do
    night_start_hour = 21
    night_end_hour = 6

    total_minutes = NaiveDateTime.diff(to_datetime, from_datetime, :minute)

    night_minutes =
      Enum.count(0..(total_minutes - 1), fn minute ->
        current_hour =
          rem(minute + NaiveDateTime.to_time(from_datetime).hour * 60, 24 * 60) |> div(60)

        current_hour >= night_start_hour or current_hour < night_end_hour
      end)

    night_minutes
  end

  defp convert_to_hours(minutes) do
    hours = div(minutes, 60)
    remaining_minutes = rem(minutes, 60)

    hours + remaining_minutes / 60.0
  end
end
