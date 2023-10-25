defmodule Timemanager.Time.WorkingTimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_time" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_times, attrs) do
    working_times
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
