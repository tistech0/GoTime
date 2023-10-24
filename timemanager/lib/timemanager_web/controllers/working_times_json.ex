defmodule TimemanagerWeb.WorkingTimesJSON do
  alias Timemanager.Time.WorkingTimes

  @doc """
  Renders a list of working_time.
  """
  def index(%{working_time: working_time}) do
    %{data: for(working_times <- working_time, do: data(working_times))}
  end

  @doc """
  Renders a single working_times.
  """
  def show(%{working_times: working_times}) do
    %{data: data(working_times)}
  end

  defp data(%WorkingTimes{} = working_times) do
    %{
      id: working_times.id,
      start: working_times.start,
      end: working_times.end
    }
  end
end
