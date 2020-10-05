defmodule Invaders.Game do
  @moduledoc """
  This holds the core logic for running a game of space invaders for one person
  """
  use GenServer
  require Logger

  @width 400
  @height 600
  @middle div(@width, 2)
  @missile_speed 30
  @ship_speed 8
  @enemy_speed 2
  @enemies_down_shift 5
  @layers 4
  @ships_per_layer 11

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
            hits: [],
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
      |> Map.replace!(:pid, self())

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
    # clear out explosions
    |> Map.replace!(:hits, [])
    |> move_enemies()
    |> move_missiles()
    |> detect_collisions()
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
      |> Map.replace!(:ship_location, bounded(next_pos))
      |> start()

    {:reply, game, game}
  end

  @doc """
  Add a new missile to the list, giving it the position above the player's ship
  """
  def handle_call({:fire_missile}, _from, game) do
    game =
      game
      |> Map.replace!(:ship_missiles, [new_missile(game.ship_location) | game.ship_missiles])

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
    |> Map.replace!(:started, true)
    |> tick()
  end

  def gen_enemies(%{enemies: _enemies} = game) do
    if win?(game) do
      Map.merge(game, %{game_over: true, win: true, enemies: []})
    else
      generated_enemies =
        1..@layers
        |> Enum.reduce([], fn layer, acc -> gen_layer(layer) ++ acc end)

      Map.replace!(game, :enemies, generated_enemies)
    end
  end

  defp gen_layer(layer) do
    ship_spacing = 30
    layer_spacing = layer * 40

    1..@ships_per_layer
    |> Enum.reduce([], fn i, acc -> [{i * ship_spacing, layer_spacing} | acc] end)
  end

  def move_enemies(%{enemies: enemies, enemies_direction: direction} = game) do
    if win?(game) do
      Map.merge(game, %{game_over: true, win: true, enemies: []})
    else
      {enemies, direction} =
        cond do
          can_move?(enemies, direction) ->
            enemies |> move_ships(direction)

          true ->
            enemies
            |> move_ships(reverse(direction))
            |> move_ships_down()
        end

      game
      |> Map.replace!(:enemies, enemies)
      |> Map.replace!(:enemies_direction, direction)
      |> player_loses?(enemies)
    end
  end

  defp move_ships(enemies, :right) do
    enemies =
      enemies
      |> Enum.map(fn {x, y} -> {x + @enemy_speed, y} end)

    {enemies, :right}
  end

  defp move_ships(enemies, :left) do
    enemies =
      enemies
      |> Enum.map(fn {x, y} -> {x + @enemy_speed * -1, y} end)

    {enemies, :left}
  end

  defp move_ships_down({enemies, direction}) do
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

  defp player_loses?(game, enemies) do
    {_x, y} = Enum.max(enemies)

    cond do
      y >= @height -> Map.replace!(game, :game_over, true)
      true -> game
    end
  end

  def move_missiles(%{ship_missiles: missiles} = game) do
    missiles =
      missiles
      |> Enum.filter(fn {_x, y} -> y - @missile_speed >= 0 end)
      |> Enum.map(fn {x, y} -> {x, y - @missile_speed} end)

    Map.replace!(game, :ship_missiles, missiles)
  end

  @doc """
  This will determine if a ship missile hits and enemy
  """
  def detect_collisions(%{ship_missiles: [], enemies: _enemies} = game),
    do: game

  def detect_collisions(%{ship_missiles: missiles, enemies: enemies} = game) do
    hits =
      Enum.reduce(enemies, %{enemies: [], missiles: []}, fn enemy, hits ->
        Enum.reduce(missiles, hits, fn missile, hits ->
          case is_hit?(enemy, missile) do
            true ->
              hits
              |> Map.put(:enemies, [enemy | hits.enemies])
              |> Map.put(:missiles, [missile | hits.missiles])

            false ->
              hits
          end
        end)
      end)

    game
    |> remove_collisions(hits)
  end

  defp remove_collisions(game, %{enemies: [], missiles: []}), do: game

  defp remove_collisions(game, %{enemies: enemies, missiles: missiles}) do
    game
    |> Map.replace!(:enemies, Enum.reject(game.enemies, &Enum.member?(enemies, &1)))
    |> Map.replace!(:ship_missiles, Enum.reject(game.ship_missiles, &Enum.member?(missiles, &1)))
    |> Map.replace!(:hits, enemies)
    |> Map.replace!(:score, game.score + 10 * length(missiles))
  end

  defp is_hit?({enemy_x, enemy_y}, {missile_x, missile_y}) do
    x_range = (enemy_x - 14)..(enemy_x + 14)
    y_range = (enemy_y - 16)..(enemy_y + 16)

    Enum.member?(x_range, missile_x) && Enum.member?(y_range, missile_y)
  end

  def win?(%{enemies: enemies, t: t}) do
    case t do
      0 -> false
      _ -> length(enemies) == 0
    end
  end

  @doc """
  Terminate the game
  """
  def stop_game(%{pid: pid}) do
    Logger.debug("Game is terminating #{inspect(pid)}")
    GenServer.stop(pid, :shutdown)
  end
end
