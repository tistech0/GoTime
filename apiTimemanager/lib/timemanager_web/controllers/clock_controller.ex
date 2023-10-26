defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.Time
  alias Timemanager.Time.Clock

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
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
    clock = Time.get_clock!(userID)
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
