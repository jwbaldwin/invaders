defmodule Invaders.SpaceInvaders do
  def new,
    do:
      start_game(
        :"game_#{:erlang.unique_integer()}",
        :"player_#{:erlang.unique_integer()}"
      )

  defp start_game(game_id, player_id) do
    Invaders.SingePlayer.Server.start_link(round_id, player_id)
  end
end

defmodule Invaders.SinglePlayer.Server do
  use GenServer

  def start_link(round_id, player_id),
    do: GenServer.start_link(__MODULE__, {round_id, player_id}, name: round_id)
end
