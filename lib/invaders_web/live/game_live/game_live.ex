defmodule InvadersWeb.GameLive do
  use InvadersWeb, :live_view

  alias Invaders.Scoreboard.Score

  @left_key "ArrowLeft"
  @right_key "ArrowRight"
  @space_key " "

  @movement_keys [@left_key, @right_key]
  @action_keys [@space_key]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, game} = Invaders.Game.new([])

    socket =
      socket
      |> assign(%{game: game, play_sound: false})

    handle_info(:update, socket)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :game_over, _params) do
    assign(socket, :score, %Score{score: socket.assigns.game.score})
  end

  @impl true
  def handle_info(:update, socket) do
    game = socket.assigns[:game] |> Invaders.Game.update()

    if game.game_over do
      {:noreply, push_patch(socket, to: Routes.game_path(socket, :game_over))}
    else
      :timer.send_after(50, self(), :update)
      {:noreply, assign(socket, :game, game)}
    end
  end

  @impl true
  def handle_info(:reset, socket) do
    {:noreply, assign(socket, :play_sound, false)}
  end

  @impl true
  def handle_event("move", %{"key" => key}, socket) when key in @movement_keys do
    game = move_ship(socket, key)
    {:noreply, assign(socket, :game, game)}
  end

  @impl true
  def handle_event("fire", %{"key" => key}, socket) when key in @action_keys do
    game = perform_action(socket)

    :timer.send_after(300, self(), :reset)

    {:noreply, assign(socket, %{game: game, play_sound: true})}
  end

  @impl true
  def handle_event("move", %{"key" => _key}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("fire", %{"key" => _key}, socket) do
    {:noreply, socket}
  end

  defp move_ship(socket, key) do
    direction = direction(key)

    socket.assigns[:game]
    |> Invaders.Game.move(direction)
  end

  defp perform_action(socket) do
    socket.assigns[:game]
    |> Invaders.Game.fire_missile()
  end

  defp direction(@left_key), do: :left
  defp direction(@right_key), do: :right
end
