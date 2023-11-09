defmodule Timemanager.TimeTest do
  use Timemanager.DataCase

  alias Timemanager.Time

  describe "clocks" do
    alias Timemanager.Time.Clock

    import Timemanager.TimeFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Time.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Time.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2023-10-23 14:12:00]}

      assert {:ok, %Clock{} = clock} = Time.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2023-10-23 14:12:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2023-10-24 14:12:00]}

      assert {:ok, %Clock{} = clock} = Time.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2023-10-24 14:12:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_clock(clock, @invalid_attrs)
      assert clock == Time.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Time.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Time.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Time.change_clock(clock)
    end
  end

  describe "working_time" do
    alias Timemanager.Time.WorkingTimes

    import Timemanager.TimeFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_working_time/0 returns all working_time" do
      working_times = working_times_fixture()
      assert Time.list_working_time() == [working_times]
    end

    test "get_working_times!/1 returns the working_times with given id" do
      working_times = working_times_fixture()
      assert Time.get_working_times!(working_times.id) == working_times
    end

    test "create_working_times/1 with valid data creates a working_times" do
      valid_attrs = %{end: ~N[2023-10-23 14:13:00], start: ~N[2023-10-23 14:13:00]}

      assert {:ok, %WorkingTimes{} = working_times} = Time.create_working_times(valid_attrs)
      assert working_times.end == ~N[2023-10-23 14:13:00]
      assert working_times.start == ~N[2023-10-23 14:13:00]
    end

    test "create_working_times/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_working_times(@invalid_attrs)
    end

    test "update_working_times/2 with valid data updates the working_times" do
      working_times = working_times_fixture()
      update_attrs = %{end: ~N[2023-10-24 14:13:00], start: ~N[2023-10-24 14:13:00]}

      assert {:ok, %WorkingTimes{} = working_times} =
               Time.update_working_times(working_times, update_attrs)

      assert working_times.end == ~N[2023-10-24 14:13:00]
      assert working_times.start == ~N[2023-10-24 14:13:00]
    end

    test "update_working_times/2 with invalid data returns error changeset" do
      working_times = working_times_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Time.update_working_times(working_times, @invalid_attrs)

      assert working_times == Time.get_working_times!(working_times.id)
    end

    test "delete_working_times/1 deletes the working_times" do
      working_times = working_times_fixture()
      assert {:ok, %WorkingTimes{}} = Time.delete_working_times(working_times)
      assert_raise Ecto.NoResultsError, fn -> Time.get_working_times!(working_times.id) end
    end

    test "change_working_times/1 returns a working_times changeset" do
      working_times = working_times_fixture()
      assert %Ecto.Changeset{} = Time.change_working_times(working_times)
    end
  end
end
