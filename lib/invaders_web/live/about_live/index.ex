defmodule InvadersWeb.AboutLive.Index do
  use InvadersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "About | Invaders")
  end
end
