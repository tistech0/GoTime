defmodule Timemanager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimemanagerWeb.Telemetry,
      Timemanager.Repo,
      {DNSCluster, query: Application.get_env(:timemanager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Timemanager.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Timemanager.Finch},
      # Start a worker by calling: Timemanager.Worker.start_link(arg)
      # {Timemanager.Worker, arg},
      # Start to serve requests, typically the last entry
      TimemanagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timemanager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimemanagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
