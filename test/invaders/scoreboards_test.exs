defmodule Invaders.ScoreboardsTest do
  use Invaders.DataCase

  alias Invaders.Scoreboards

  describe "scoreboards" do
    alias Invaders.Scoreboards.Scoreboard

    @valid_attrs %{name: "some name", score: 42}
    @update_attrs %{name: "some updated name", score: 43}
    @invalid_attrs %{name: nil, score: nil}

    def scoreboard_fixture(attrs \\ %{}) do
      {:ok, scoreboard} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scoreboards.create_scoreboard()

      scoreboard
    end

    test "list_scoreboards/0 returns all scoreboards" do
      scoreboard = scoreboard_fixture()
      assert Scoreboards.list_scoreboards() == [scoreboard]
    end

    test "get_scoreboard!/1 returns the scoreboard with given id" do
      scoreboard = scoreboard_fixture()
      assert Scoreboards.get_scoreboard!(scoreboard.id) == scoreboard
    end

    test "create_scoreboard/1 with valid data creates a scoreboard" do
      assert {:ok, %Scoreboard{} = scoreboard} = Scoreboards.create_scoreboard(@valid_attrs)
      assert scoreboard.name == "some name"
      assert scoreboard.score == 42
    end

    test "create_scoreboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scoreboards.create_scoreboard(@invalid_attrs)
    end

    test "update_scoreboard/2 with valid data updates the scoreboard" do
      scoreboard = scoreboard_fixture()
      assert {:ok, %Scoreboard{} = scoreboard} = Scoreboards.update_scoreboard(scoreboard, @update_attrs)
      assert scoreboard.name == "some updated name"
      assert scoreboard.score == 43
    end

    test "update_scoreboard/2 with invalid data returns error changeset" do
      scoreboard = scoreboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Scoreboards.update_scoreboard(scoreboard, @invalid_attrs)
      assert scoreboard == Scoreboards.get_scoreboard!(scoreboard.id)
    end

    test "delete_scoreboard/1 deletes the scoreboard" do
      scoreboard = scoreboard_fixture()
      assert {:ok, %Scoreboard{}} = Scoreboards.delete_scoreboard(scoreboard)
      assert_raise Ecto.NoResultsError, fn -> Scoreboards.get_scoreboard!(scoreboard.id) end
    end

    test "change_scoreboard/1 returns a scoreboard changeset" do
      scoreboard = scoreboard_fixture()
      assert %Ecto.Changeset{} = Scoreboards.change_scoreboard(scoreboard)
    end
  end
end
