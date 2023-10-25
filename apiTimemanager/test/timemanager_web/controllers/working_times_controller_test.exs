defmodule TimemanagerWeb.WorkingTimesControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.TimeFixtures

  alias Timemanager.Time.WorkingTimes

  @create_attrs %{
    end: ~N[2023-10-23 14:13:00],
    start: ~N[2023-10-23 14:13:00]
  }
  @update_attrs %{
    end: ~N[2023-10-24 14:13:00],
    start: ~N[2023-10-24 14:13:00]
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all working_time", %{conn: conn} do
      conn = get(conn, ~p"/api/working_time")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_times" do
    test "renders working_times when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/working_time", working_times: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/working_time/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2023-10-23T14:13:00",
               "start" => "2023-10-23T14:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/working_time", working_times: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_times" do
    setup [:create_working_times]

    test "renders working_times when data is valid", %{conn: conn, working_times: %WorkingTimes{id: id} = working_times} do
      conn = put(conn, ~p"/api/working_time/#{working_times}", working_times: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/working_time/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2023-10-24T14:13:00",
               "start" => "2023-10-24T14:13:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working_times: working_times} do
      conn = put(conn, ~p"/api/working_time/#{working_times}", working_times: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_times" do
    setup [:create_working_times]

    test "deletes chosen working_times", %{conn: conn, working_times: working_times} do
      conn = delete(conn, ~p"/api/working_time/#{working_times}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/working_time/#{working_times}")
      end
    end
  end

  defp create_working_times(_) do
    working_times = working_times_fixture()
    %{working_times: working_times}
  end
end
