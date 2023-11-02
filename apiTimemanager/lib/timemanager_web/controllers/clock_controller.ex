defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.Time
  alias Timemanager.Time.Clock

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def createOrUpdate(conn, %{"clock" => clock_params}) do
    user_id = conn.params["userID"]
    case Time.get_clock_by_user_id!(user_id) do
      %Clock{} = clock ->
        current_status = clock.status

        if current_status do
          end_time = DateTime.utc_now()
          start_time = clock.time

          working_time_params = %{
            "start" => start_time,
            "end" => end_time,
            "value" => Time.hours_between(start_time, end_time),
            "status" => "validated"
          }
          with {:ok, %Timemanager.Time.WorkingTimes{} = working_times} <-
            Time.create_working_times(working_time_params, user_id) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", ~p"/api/working_time/#{working_times}")
            |> json(TimemanagerWeb.WorkingTimesJSON.show(%{working_times: working_times}))
          end
        end
        updated_status = !current_status
        clock_params_with_status = Map.put(clock_params, "status", updated_status)
        with {:ok, updated_clock} <- Time.update_clock(clock, clock_params_with_status) do
          conn
          |> put_status(:ok)
          |> render(:show, clock: updated_clock)
        end

      nil ->
        clock_params_with_status = Map.put(clock_params, "status", true)
        with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params_with_status, user_id) do
          conn
          |> put_status(:created)  # Utilisez :created pour indiquer qu'une nouvelle ressource a été créée.
          |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
          |> render(:show, clock: clock)
        end
    end
  end

  def create(conn, %{"clock" => clock_params}) do
    user_id = conn.params["userID"]
    with {:ok, %Clock{} = clock} <- Time.create_clock(clock_params, user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"userID" => userID}) do
    clock = Time.get_clock_by_user_id!(userID)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
