defmodule InvadersWeb.ScoreboardLive.Index do
  use InvadersWeb, :live_view

  alias Invaders.Scoreboards
  alias Invaders.Scoreboards.Scoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :scoreboards, list_scoreboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Scoreboard")
    |> assign(:scoreboard, Scoreboards.get_scoreboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scoreboard")
    |> assign(:scoreboard, %Scoreboard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scoreboards")
    |> assign(:scoreboard, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scoreboard = Scoreboards.get_scoreboard!(id)
    {:ok, _} = Scoreboards.delete_scoreboard(scoreboard)

    {:noreply, assign(socket, :scoreboards, list_scoreboards())}
  end

  defp list_scoreboards do
    Scoreboards.list_scoreboards()
  end
end
