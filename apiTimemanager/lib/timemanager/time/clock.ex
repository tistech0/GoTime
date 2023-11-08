defmodule Timemanager.Time.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    belongs_to :user, Timemanager.Account.User, foreign_key: :user_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
  end

  @doc false
  def changeset(clock, attrs, user_id) do
    clock
    |> cast(attrs, [:time, :status])
    |> validate_required([:time, :status])
    |> put_assoc(:user, Timemanager.Account.User.get_user!(user_id))
  end
end
