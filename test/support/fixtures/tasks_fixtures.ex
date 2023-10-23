defmodule TimeManager.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: true,
        title: "some title"
      })
      |> TimeManager.Tasks.create_task()

    task
  end
end
