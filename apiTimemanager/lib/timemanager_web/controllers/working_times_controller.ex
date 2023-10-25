defmodule TimemanagerWeb.WorkingTimesController do
  use TimemanagerWeb, :controller

  alias Timemanager.Time
  alias Timemanager.Time.WorkingTimes

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    working_time = Time.list_working_time()
    render(conn, :index, working_time: working_time)
  end

  def create(conn, %{"working_times" => working_times_params}) do
    with {:ok, %WorkingTimes{} = working_times} <- Time.create_working_times(working_times_params) do
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

    with {:ok, %WorkingTimes{} = working_times} <- Time.update_working_times(working_times, working_times_params) do
      render(conn, :show, working_times: working_times)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_times = Time.get_working_times!(id)

    with {:ok, %WorkingTimes{}} <- Time.delete_working_times(working_times) do
      send_resp(conn, :no_content, "")
    end
  end
end
