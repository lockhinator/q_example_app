defmodule Qapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      QappWeb.Telemetry,
      # Start the Ecto repository
      Qapp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Qapp.PubSub},
      # Start Finch
      {Finch, name: Qapp.Finch},
      # Start the Endpoint (http/https)
      QappWeb.Endpoint
      # Start a worker by calling: Qapp.Worker.start_link(arg)
      # {Qapp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Qapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
