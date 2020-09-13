defmodule Invaders.ScoreboardTest do
  use Invaders.DataCase

  alias Invaders.Scoreboard

  describe "scores" do
    alias Invaders.Scoreboard.Score

    @valid_attrs %{name: "some name", score: 42}
    @update_attrs %{name: "some updated name", score: 43}
    @invalid_attrs %{name: nil, score: nil}

    def score_fixture(attrs \\ %{}) do
      {:ok, score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scoreboard.create_score()

      score
    end

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Scoreboard.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Scoreboard.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      assert {:ok, %Score{} = score} = Scoreboard.create_score(@valid_attrs)
      assert score.name == "some name"
      assert score.score == 42
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scoreboard.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      assert {:ok, %Score{} = score} = Scoreboard.update_score(score, @update_attrs)
      assert score.name == "some updated name"
      assert score.score == 43
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Scoreboard.update_score(score, @invalid_attrs)
      assert score == Scoreboard.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Scoreboard.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Scoreboard.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Scoreboard.change_score(score)
    end
  end
end
