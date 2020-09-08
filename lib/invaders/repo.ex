defmodule Invaders.Repo do
  use Ecto.Repo,
    otp_app: :invaders,
    adapter: Ecto.Adapters.Postgres
end
