defmodule InvadersWeb.ScoreboardLiveTest do
  use InvadersWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Invaders.Scoreboards

  @create_attrs %{name: "some name", score: 42}
  @update_attrs %{name: "some updated name", score: 43}
  @invalid_attrs %{name: nil, score: nil}

  defp fixture(:scoreboard) do
    {:ok, scoreboard} = Scoreboards.create_scoreboard(@create_attrs)
    scoreboard
  end

  defp create_scoreboard(_) do
    scoreboard = fixture(:scoreboard)
    %{scoreboard: scoreboard}
  end

  describe "Index" do
    setup [:create_scoreboard]

    test "lists all scoreboards", %{conn: conn, scoreboard: scoreboard} do
      {:ok, _index_live, html} = live(conn, Routes.scoreboard_index_path(conn, :index))

      assert html =~ "Listing Scoreboards"
      assert html =~ scoreboard.name
    end

    test "saves new scoreboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.scoreboard_index_path(conn, :index))

      assert index_live |> element("a", "New Scoreboard") |> render_click() =~
               "New Scoreboard"

      assert_patch(index_live, Routes.scoreboard_index_path(conn, :new))

      assert index_live
             |> form("#scoreboard-form", scoreboard: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#scoreboard-form", scoreboard: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.scoreboard_index_path(conn, :index))

      assert html =~ "Scoreboard created successfully"
      assert html =~ "some name"
    end

    test "updates scoreboard in listing", %{conn: conn, scoreboard: scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.scoreboard_index_path(conn, :index))

      assert index_live |> element("#scoreboard-#{scoreboard.id} a", "Edit") |> render_click() =~
               "Edit Scoreboard"

      assert_patch(index_live, Routes.scoreboard_index_path(conn, :edit, scoreboard))

      assert index_live
             |> form("#scoreboard-form", scoreboard: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#scoreboard-form", scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.scoreboard_index_path(conn, :index))

      assert html =~ "Scoreboard updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes scoreboard in listing", %{conn: conn, scoreboard: scoreboard} do
      {:ok, index_live, _html} = live(conn, Routes.scoreboard_index_path(conn, :index))

      assert index_live |> element("#scoreboard-#{scoreboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#scoreboard-#{scoreboard.id}")
    end
  end

  describe "Show" do
    setup [:create_scoreboard]

    test "displays scoreboard", %{conn: conn, scoreboard: scoreboard} do
      {:ok, _show_live, html} = live(conn, Routes.scoreboard_show_path(conn, :show, scoreboard))

      assert html =~ "Show Scoreboard"
      assert html =~ scoreboard.name
    end

    test "updates scoreboard within modal", %{conn: conn, scoreboard: scoreboard} do
      {:ok, show_live, _html} = live(conn, Routes.scoreboard_show_path(conn, :show, scoreboard))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Scoreboard"

      assert_patch(show_live, Routes.scoreboard_show_path(conn, :edit, scoreboard))

      assert show_live
             |> form("#scoreboard-form", scoreboard: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#scoreboard-form", scoreboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.scoreboard_show_path(conn, :show, scoreboard))

      assert html =~ "Scoreboard updated successfully"
      assert html =~ "some updated name"
    end
  end
end
