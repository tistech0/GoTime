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

  def getWithStartEnd(conn, %{"userID" => user_id, "start" => start_time, "end" => end_time}) do
    working_times =
      Timemanager.Time.get_working_times_by_user_id_and_start_and_end_time(
        user_id,
        start_time,
        end_time
      )

    render(conn, :render_working_times_list, working_times: working_times)
  end
end
