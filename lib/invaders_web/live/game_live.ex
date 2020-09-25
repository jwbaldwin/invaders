defmodule InvadersWeb.GameLive do
  use InvadersWeb, :live_view

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
  def handle_info(:update, socket) do
    game = socket.assigns[:game] |> Invaders.Game.update()

    unless game.game_over do
      :timer.send_after(50, self(), :update)
    end

    {:noreply, assign(socket, :game, game)}
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
