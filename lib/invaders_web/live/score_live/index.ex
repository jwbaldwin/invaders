defmodule InvadersWeb.ScoreLive.Index do
  use InvadersWeb, :live_view

  alias Invaders.Scoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :scores, list_scores())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scores")
    |> assign(:score, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    score = Scoreboard.get_score!(id)
    {:ok, _} = Scoreboard.delete_score(score)

    {:noreply, assign(socket, :scores, list_scores())}
  end

  defp list_scores do
    Scoreboard.list_scores()
  end
end
