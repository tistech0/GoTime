defmodule Timemanager.Time.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    field :user_id, :

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status])
    |> validate_required([:time, :status])
  end

  @doc false
  def changeset(clock, attrs, user_id) do
    clock
    |> cast(attrs, [:time, :status])
    |> validate_required([:time, :status])
    |> put_change(:user_id, user_id)
  end
end
