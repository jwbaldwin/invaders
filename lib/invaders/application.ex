defmodule Invaders.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Invaders.Repo,
      # Start the Telemetry supervisor
      InvadersWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Invaders.PubSub},
      # Start the Endpoint (http/https)
      InvadersWeb.Endpoint
      # Start a worker by calling: Invaders.Worker.start_link(arg)
      # {Invaders.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Invaders.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InvadersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
