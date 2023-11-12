defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.Time
  alias Timemanager.Time.Clock
  alias TimemanagerWeb.ErrorTemplate

  action_fallback TimemanagerWeb.FallbackController

  def createOrUpdate(conn, %{"clock" => clock_params}) do
    user_id = conn.params["userID"]

    case Time.get_clock_by_user_id!(user_id) do
      %Clock{} = clock ->
        current_status = clock.status

        if current_status do
          case NaiveDateTime.from_iso8601(clock_params["time"]) do
            {:ok, datetime} ->
              start_time = clock.time
              end_time = datetime
              {day_hours, night_hours} = Time.calculate_day_and_night_hours(start_time, end_time)

              working_time_params = %{
                "start" => start_time,
                "end" => end_time,
                "valueDay" => day_hours,
                "valueNight" => night_hours,
                "status" => "validated"
              }

              with {:ok, %Timemanager.Time.WorkingTimes{} = working_times} <-
                     Time.create_working_times(working_time_params, user_id) do
                conn
                |> put_status(:created)
                |> json(TimemanagerWeb.WorkingTimesJSON.show(%{working_times: working_times}))
              end

            {:error, reason} ->
              ErrorTemplate.error_template(conn, 400, "Error converting date " <> reason)
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
          |> put_status(:created)
          |> render(:show, clock: clock)
        end
    end
  end

  def show(conn, %{"userID" => userID}) do
    try do
      clock = Time.get_clock_by_user_id!(userID)
      render(conn, :show, clock: clock)
    rescue
      _ -> ErrorTemplate.error_template(conn, 400, "Error whit the user id")
    end
  end
end
