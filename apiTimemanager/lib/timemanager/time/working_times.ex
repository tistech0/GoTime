defmodule Timemanager.Time.WorkingTimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_time" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :valueDay, :float
    field :valueNight, :float
    field :status, :string
    belongs_to :user, Timemanager.Account.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_times, attrs) do
    working_times
    |> cast(attrs, [:start, :end, :valueDay, :valueNight, :status, :user_id])
    |> validate_required([:start, :end, :valueDay, :valueNight, :status, :user_id])
  end

  def changeset(working_times, attrs, user_id) do
    user_id = String.to_integer(user_id)

    working_times
    |> cast(attrs, [:start, :end, :valueDay, :valueNight, :status])
    |> validate_required([:start, :end, :valueDay, :valueNight, :status])
    |> put_assoc(:user, Timemanager.Account.User.get_user!(user_id))
  end
end
