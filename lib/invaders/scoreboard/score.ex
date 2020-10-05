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
    IO.puts("getting")

    score =
      score
      |> cast(attrs, [:name, :score])
      |> validate_length(:name, is: 3)
      |> validate_format(:name, ~r/[a-zA-Z]+/, message: "Only letters are allowed. ")
      |> validate_required([:name, :score])

    IO.inspect(attrs)
    IO.inspect(score)
  end
end
