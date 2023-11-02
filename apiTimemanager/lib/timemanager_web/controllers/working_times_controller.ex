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
      |> put_resp_header("location", ~p"/api/working_time/#{working_times}")
      |> render(:show, working_times: working_times)
    end
  end

  def show(conn, %{"id" => id}) do
    working_times = Time.get_working_times!(id)
    render(conn, :show, working_times: working_times)
  end

  def update(conn, %{"id" => id, "working_times" => working_times_params}) do
    working_times = Time.get_working_times!(id)

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
          user.id,  # Assuming there's an `id` field in the user struct
          start_time,
          end_time
        )
      end)
    # Finally, render the working times list (if needed)
    render(conn, :render_working_times_list, working_times: working_times)
  end
end
