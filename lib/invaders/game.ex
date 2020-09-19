defmodule Invaders.Game do
  @moduledoc """
  This holds the core logic for running a game of space invaders for one person
  """
  use GenServer
  require Logger

  @width 400
  @height 600
  @middle div(@width, 2)
  @missile_speed 15
  @ship_speed 5
  @enemies_down_shift 15

  defstruct started: false,
            pid: nil,
            game_over: false,
            win: false,
            t: 0,
            width: @width,
            height: @height,
            ship_location: @middle - 20,
            ship_missiles: [],
            enemies: [],
            enemies_direction: :right,
            enemy_missiles: [],
            bases: [],
            lives: 3,
            score: 0

  @doc """
  Start a new snake game
  """
  def new(args) do
    {:ok, pid} = start_link(args)
    {:ok, state(pid)}
  end

  @doc """
  Initialize the game board
  """
  def init(_) do
    game =
      %__MODULE__{}
      |> gen_enemies()
      |> Map.put(:pid, self())

    {:ok, game}
  end

  def start_link(_args) do
    GenServer.start(__MODULE__, [])
  end

  @doc """
  Gets the state of the game from the genserver
  """
  def state(%__MODULE__{pid: pid}) do
    state(pid)
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  @doc """
  Move left or right, :left | :right
  """
  def move(%__MODULE__{pid: pid}, dir) do
    move(pid, dir)
  end

  def move(pid, dir) do
    GenServer.call(pid, {:move, dir})
  end

  @doc """
  Fire a missile
  """
  def fire_missile(%__MODULE__{pid: pid}) do
    fire_missile(pid)
  end

  def fire_missile(pid) do
    GenServer.call(pid, {:fire_missile})
  end

  @doc """
  Tick the game state, move aliens and missles
  """
  def tick(game) do
    game
    |> Map.update!(:t, &(&1 + 1))
    |> move_enemies()
    |> move_missiles()
  end

  def update(%__MODULE__{pid: pid}) do
    update(pid)
  end

  def update(pid) do
    GenServer.call(pid, :update)
  end

  def handle_call(:state, _from, game) do
    {:reply, game, game}
  end

  def handle_call(:update, _from, game) do
    game =
      game
      |> tick()

    {:reply, game, game}
  end

  def handle_call({:move, direction}, _from, game) do
    next_pos = next_pos(direction, game.ship_location)

    game =
      game
      |> Map.put(:ship_location, bounded(next_pos))
      |> start()

    {:reply, game, game}
  end

  @doc """
  Add a new missile to the list, giving it the position above the player's ship
  """
  def handle_call({:fire_missile}, _from, game) do
    game =
      game
      |> Map.put(:ship_missiles, [new_missile(game.ship_location) | game.ship_missiles])

    {:reply, game, game}
  end

  defp new_missile(ship_location) do
    {ship_location + 20, @height - 50}
  end

  defp next_pos(direction, ship_location) do
    case direction do
      :left -> ship_location - @ship_speed
      :right -> ship_location + @ship_speed
      _ -> ship_location
    end
  end

  defp bounded(position) do
    adjustment = 20

    cond do
      position > @width - adjustment -> @width - adjustment
      position < 0 - adjustment -> 0 - adjustment
      true -> position
    end
  end

  def start(%{started: true} = game), do: game

  def start(game) do
    Logger.debug("Game started: #{inspect(game.pid)}")

    game
    |> Map.put(:started, true)
    |> tick()
  end

  def gen_enemies(%{enemies: _enemies} = game) do
    if win?(game) do
      Map.merge(game, %{game_over: true, win: true, enemies: []})
    else
      generated_enemies =
        1..2
        |> Enum.reduce([], fn layer, acc -> gen_layer(layer) ++ acc end)

      Map.put(game, :enemies, generated_enemies)
    end
  end

  defp gen_layer(layer) do
    ship_spacing = 40
    layer_spacing = layer * 40
    offset = layer * 20

    1..5
    |> Enum.reduce([], fn i, acc -> [{i * ship_spacing + offset, layer_spacing} | acc] end)
  end

  def move_enemies(%{enemies: enemies, enemies_direction: direction} = game) do
    {enemies, direction} =
      cond do
        can_move?(enemies, direction) ->
          enemies |> move_ships(direction)

        true ->
          enemies
          |> move_ships(reverse(direction))
          |> move_ships_down(reverse(direction))
      end

    game
    |> Map.put(:enemies, enemies)
    |> Map.put(:enemies_direction, direction)
  end

  defp move_ships(enemies, :right) do
    enemies
    |> Enum.map(fn {x, y} -> {x + @ship_speed, y} end)
  end

  defp move_ships(enemies, :left) do
    enemies
    |> Enum.map(fn {x, y} -> {x + @ship_speed * -1, y} end)
  end

  defp move_ships_down(enemies, direction) do
    # TODO: make sure to end the game or something if y >= @height
    enemies =
      enemies
      |> Enum.map(fn {x, y} -> {x, y + @enemies_down_shift} end)

    {enemies, direction}
  end

  defp can_move?(enemies, direction) do
    case direction do
      :right ->
        {x, _y} = Enum.max(enemies)
        x <= @width - 24

      :left ->
        {x, _y} = Enum.min(enemies)
        x >= 20
    end
  end

  defp reverse(:left), do: :right
  defp reverse(:right), do: :left

  def move_missiles(%{ship_missiles: missiles} = game) do
    missiles =
      missiles
      |> Enum.filter(fn {_x, y} -> y - @missile_speed >= 0 end)
      |> Enum.map(fn {x, y} -> {x, y - @missile_speed} end)

    Map.put(game, :ship_missiles, missiles)
  end

  def win?(%{enemies: _enemies}) do
    false
    # Map.length(enemies) == 0
  end

  @doc """
  Terminate the game
  """
  def stop_game(%{pid: pid}) do
    Logger.debug("Game is terminating #{inspect(pid)}")
    GenServer.stop(pid, :shutdown)
  end
end
