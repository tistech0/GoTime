defmodule Timemanager.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Time` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2023-10-23 14:12:00]
      })
      |> Timemanager.Time.create_clock()

    clock
  end

  @doc """
  Generate a working_times.
  """
  def working_times_fixture(attrs \\ %{}) do
    {:ok, working_times} =
      attrs
      |> Enum.into(%{
        end: ~N[2023-10-23 14:13:00],
        start: ~N[2023-10-23 14:13:00]
      })
      |> Timemanager.Time.create_working_times()

    working_times
  end
end
