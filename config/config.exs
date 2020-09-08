# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :invaders,
  ecto_repos: [Invaders.Repo]

# Configures the endpoint
config :invaders, InvadersWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QPcrb3Fgr4CoUK3tWaCBDkw64wsOzpCaYnC78lNDpg7n7z7rgt1dA8EMXneWgDGF",
  render_errors: [view: InvadersWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Invaders.PubSub,
  live_view: [signing_salt: "Ety+p5JT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
