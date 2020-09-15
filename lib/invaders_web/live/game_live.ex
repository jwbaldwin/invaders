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
      |> assign(:game, game)

    handle_info(:update, socket)

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    game = socket.assigns[:game] |> Invaders.Game.update()

    unless game.game_over do
      :timer.send_after(1000, self(), :update)
    end

    {:noreply, assign(socket, :game, game)}
  end

  @impl true
  def handle_event("move", %{"key" => key}, socket) when key in @movement_keys do
    direction = direction(key)
    IO.inspect(direction, label: "moving")

    game =
      socket.assigns[:game]
      |> Invaders.Game.move(direction)

    IO.inspect(game.ship_location, label: "pos")
    {:noreply, assign(socket, :game, game)}
  end

  def handle_event("move", %{"key" => key}, socket) when key in @action_keys do
    IO.inspect(key, label: "Action")

    game =
      socket.assigns[:game]
      |> Invaders.Game.fire_missile()

    {:noreply, socket}
  end

  defp direction(@left_key), do: :left
  defp direction(@right_key), do: :right
end
