defmodule InvadersWeb.ScoreLive.Show do
  use InvadersWeb, :live_view

  alias Invaders.Scoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:score, Scoreboard.get_score!(id))}
  end

  defp page_title(:show), do: "Show Score"
  defp page_title(:edit), do: "Edit Score"
end
