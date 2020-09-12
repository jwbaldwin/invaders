defmodule Invaders.Scoreboards.Scoreboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scoreboards" do
    field :name, :string
    field :score, :integer

    timestamps()
  end

  @doc false
  def changeset(scoreboard, attrs) do
    scoreboard
    |> cast(attrs, [:name, :score])
    |> validate_required([:name, :score])
  end
end
