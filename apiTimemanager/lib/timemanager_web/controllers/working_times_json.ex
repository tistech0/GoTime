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

  @doc """
  Renders a list of working times with start and end times.
  """
  def render_working_times_list(%{working_times: working_times}) do
    %{data: Enum.map(working_times, &data/1)}
  end

  defp data(%WorkingTimes{} = working_times) do
    %{
      id: working_times.id,
      start: working_times.start,
      end: working_times.end,
      valueDay: working_times.valueDay,
      valueNight: working_times.valueNight,
      status: working_times.status
    }
  end
end
