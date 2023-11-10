defmodule TimemanagerWeb.WorkingTimesController do
  use TimemanagerWeb, :controller

  alias Timemanager.Time
  alias Timemanager.Time.WorkingTimes

  action_fallback(TimemanagerWeb.FallbackController)

  def index(conn, _params) do
    working_time = Time.list_working_time()
    render(conn, :index, working_time: working_time)
  end

  def create(conn, %{"working_times" => working_times_params}) do
    user_id = conn.params["userID"]
    working_times_params = Map.put(working_times_params, "status", "waiting")

    {:ok, start_time} = Map.get(working_times_params, "start") |> NaiveDateTime.from_iso8601()
    {:ok, end_time} = Map.get(working_times_params, "end") |> NaiveDateTime.from_iso8601()

    {day_hours, night_hours} = Time.calculate_day_and_night_hours(start_time, end_time)

    working_times_params = Map.put(working_times_params, "valueDay", day_hours)
    working_times_params = Map.put(working_times_params, "valueNight", night_hours)

    with {:ok, %WorkingTimes{} = working_times} <-
           Time.create_working_times(working_times_params, user_id) do
      conn
      |> put_status(:created)
      |> render(:show, working_times: working_times)
    end
  end

  def show(conn, %{"id" => id}) do
    working_times = Time.get_working_times!(id)
    render(conn, :show, working_times: working_times)
  end

  def update(conn, %{"id" => id, "working_times" => working_times_params}) do
    working_times = Time.get_working_times!(id)
    working_times_params = Map.put(working_times_params, "status", "waiting")

    {:ok, start_time} = Map.get(working_times_params, "start") |> NaiveDateTime.from_iso8601()
    {:ok, end_time} = Map.get(working_times_params, "end") |> NaiveDateTime.from_iso8601()

    {day_hours, night_hours} = Time.calculate_day_and_night_hours(start_time, end_time)

    working_times_params = Map.put(working_times_params, "valueDay", day_hours)
    working_times_params = Map.put(working_times_params, "valueNight", night_hours)

    with {:ok, %WorkingTimes{} = working_times} <-
           Time.update_working_times(working_times, working_times_params) do
      render(conn, :show, working_times: working_times)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_times = Time.get_working_times!(id)

    with {:ok, %WorkingTimes{}} <- Time.delete_working_times(working_times) do
      send_resp(conn, :no_content, "")
    end
  end

  def getWithUserId(conn, %{"userID" => user_id, "id" => working_time_id}) do
    working_times =
      Time.get_working_times_by_user_id_and_working_time_id(user_id, working_time_id)

    render(conn, :show, working_times: working_times)
  end

  def getWithStartEndUser(conn, %{"userID" => user_id, "start" => start_time, "end" => end_time}) do
    working_times =
      Timemanager.Time.get_working_times_by_user_id_and_start_and_end_time(
        user_id,
        start_time,
        end_time
      )

    render(conn, :render_working_times_list, working_times: working_times)
  end

  def getWithStartEndTeam(conn, %{"teamID" => team_id, "start" => start_time, "end" => end_time}) do
    users_list = Timemanager.Time.get_list_user_link_team(team_id)

    # Fetch working times for all users and store them in a list
    working_times =
      users_list
      |> Enum.flat_map(fn user ->
        # You can also fetch working times for each user
        Timemanager.Time.get_working_times_by_user_id_and_start_and_end_time(
          # Assuming there's an `id` field in the user struct
          user.id,
          start_time,
          end_time
        )
      end)
      # add username and user_id to working times
      |> Enum.map(fn working_times ->
        %{
          id: working_times.id,
          start: working_times.start,
          end: working_times.end,
          valueDay: working_times.valueDay,
          valueNight: working_times.valueNight,
          status: working_times.status,
          username: get_user(working_times.user_id).username,
          user_id: working_times.user_id
        }
      end)

    # Finally, render the working times list (if needed)
    render(conn, :render_working_times_list, working_times: working_times)
  end

  def get_user(user_id) do
    Timemanager.Repo.get!(Timemanager.Account.User, user_id)
  end

  def getTeamAverageHoursPerDay(conn, %{
        "teamID" => team_id,
        "start" => start_time,
        "end" => end_time
      }) do
    users_list = Timemanager.Time.get_list_user_link_team(team_id)

    # Fetch working times for all users and store them in a list
    working_times =
      users_list
      |> Enum.flat_map(fn user ->
        # You can also fetch working times for each user
        Timemanager.Time.get_working_times_by_user_id_and_start_and_end_time(
          # Assuming there's an `id` field in the user struct
          user.id,
          start_time,
          end_time
        )
      end)

    # Group working times by day
    working_times_per_day = Enum.group_by(working_times, fn wt -> Date.to_iso8601(wt.start) end)

    # Calculate average, min and max hours per day
    hours_per_day_stats =
      Enum.map(working_times_per_day, fn {day, working_times} ->
        total_hours =
          working_times |> Enum.map(fn wt -> wt.valueDay + wt.valueNight end) |> Enum.sum()

        total_day_hours = working_times |> Enum.map(& &1.valueDay) |> Enum.sum()
        total_night_hours = working_times |> Enum.map(& &1.valueNight) |> Enum.sum()

        average_hours = total_hours / length(working_times)
        average_day_hours = total_day_hours / length(working_times)
        average_night_hours = total_night_hours / length(working_times)

        min_hours =
          if min_wt = Enum.min_by(working_times, &(&1.valueDay + &1.valueNight)),
            do: min_wt.valueDay + min_wt.valueNight,
            else: 0

        max_hours =
          if max_wt = Enum.max_by(working_times, &(&1.valueDay + &1.valueNight)),
            do: max_wt.valueDay + max_wt.valueNight,
            else: 0

        %{
          day: day,
          average: average_hours,
          average_day: average_day_hours,
          average_night: average_night_hours,
          min: min_hours,
          max: max_hours,
          total: total_hours,
          total_day: total_day_hours,
          total_night: total_night_hours
        }
      end)

    render(conn, :render_working_times_list, working_times: hours_per_day_stats)
  end
end
