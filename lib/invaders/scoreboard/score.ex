defmodule Invaders.Scoreboard.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :name, :string
    field :score, :integer

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:name, :score])
    |> validate_required([:name, :score])
  end
end
