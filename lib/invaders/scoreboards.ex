defmodule Invaders.Scoreboards do
  @moduledoc """
  The Scoreboards context.
  """

  import Ecto.Query, warn: false
  alias Invaders.Repo

  alias Invaders.Scoreboards.Scoreboard

  @doc """
  Returns the list of scoreboards.

  ## Examples

      iex> list_scoreboards()
      [%Scoreboard{}, ...]

  """
  def list_scoreboards do
    Repo.all(Scoreboard)
  end

  @doc """
  Gets a single scoreboard.

  Raises `Ecto.NoResultsError` if the Scoreboard does not exist.

  ## Examples

      iex> get_scoreboard!(123)
      %Scoreboard{}

      iex> get_scoreboard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scoreboard!(id), do: Repo.get!(Scoreboard, id)

  @doc """
  Creates a scoreboard.

  ## Examples

      iex> create_scoreboard(%{field: value})
      {:ok, %Scoreboard{}}

      iex> create_scoreboard(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scoreboard(attrs \\ %{}) do
    %Scoreboard{}
    |> Scoreboard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scoreboard.

  ## Examples

      iex> update_scoreboard(scoreboard, %{field: new_value})
      {:ok, %Scoreboard{}}

      iex> update_scoreboard(scoreboard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scoreboard(%Scoreboard{} = scoreboard, attrs) do
    scoreboard
    |> Scoreboard.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scoreboard.

  ## Examples

      iex> delete_scoreboard(scoreboard)
      {:ok, %Scoreboard{}}

      iex> delete_scoreboard(scoreboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scoreboard(%Scoreboard{} = scoreboard) do
    Repo.delete(scoreboard)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scoreboard changes.

  ## Examples

      iex> change_scoreboard(scoreboard)
      %Ecto.Changeset{data: %Scoreboard{}}

  """
  def change_scoreboard(%Scoreboard{} = scoreboard, attrs \\ %{}) do
    Scoreboard.changeset(scoreboard, attrs)
  end
end
