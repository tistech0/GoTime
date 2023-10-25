defmodule Timemanager.Repo do
  use Ecto.Repo,
    otp_app: :timemanager,
    adapter: Ecto.Adapters.Postgres
end
