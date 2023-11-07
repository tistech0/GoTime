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

  defp data(
         %{
           day: _,
           average: _,
           average_day: _,
           average_night: _,
           min: _,
           max: _,
           total: _,
           total_day: _,
           total_night: _
         } = stats
       ) do
    %{
      day: stats.day,
      average_hours: stats.average,
      average_day_hours: stats.average_day,
      average_night_hours: stats.average_night,
      total_hours: stats.total,
      total_day_hours: stats.total_day,
      total_night_hours: stats.total_night,
      min_hours: stats.min,
      max_hours: stats.max
    }
  end
end
