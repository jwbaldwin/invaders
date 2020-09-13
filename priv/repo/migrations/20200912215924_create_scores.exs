defmodule Invaders.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :name, :string
      add :score, :integer

      timestamps()
    end

  end
end
