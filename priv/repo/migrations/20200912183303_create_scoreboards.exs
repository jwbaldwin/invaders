defmodule Invaders.Repo.Migrations.CreateScoreboards do
  use Ecto.Migration

  def change do
    create table(:scoreboards) do
      add :name, :string
      add :score, :integer

      timestamps()
    end

  end
end
