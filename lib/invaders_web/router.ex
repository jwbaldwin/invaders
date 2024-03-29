defmodule InvadersWeb.Router do
  use InvadersWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {InvadersWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvadersWeb do
    pipe_through :browser

    live "/", HomeLive, :index
    live "/game", GameLive, :index
    live "/game/over", GameLive, :game_over
    live "/scores", ScoreLive.Index, :index
    live "/about", AboutLive.Index, :index

    live "/scores/:id", ScoreLive.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", InvadersWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: InvadersWeb.Telemetry
    end
  end
end
