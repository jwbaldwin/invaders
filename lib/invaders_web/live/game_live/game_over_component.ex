defmodule InvadersWeb.GameLive.GameOverComponent do
  use InvadersWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1><%= @game_ending_text %></h1>
    """
  end
end
