defmodule InvadersWeb.ScoreboardLive.FormComponent do
  use InvadersWeb, :live_component

  alias Invaders.Scoreboards

  @impl true
  def update(%{scoreboard: scoreboard} = assigns, socket) do
    changeset = Scoreboards.change_scoreboard(scoreboard)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"scoreboard" => scoreboard_params}, socket) do
    changeset =
      socket.assigns.scoreboard
      |> Scoreboards.change_scoreboard(scoreboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"scoreboard" => scoreboard_params}, socket) do
    save_scoreboard(socket, socket.assigns.action, scoreboard_params)
  end

  defp save_scoreboard(socket, :edit, scoreboard_params) do
    case Scoreboards.update_scoreboard(socket.assigns.scoreboard, scoreboard_params) do
      {:ok, _scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Scoreboard updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_scoreboard(socket, :new, scoreboard_params) do
    case Scoreboards.create_scoreboard(scoreboard_params) do
      {:ok, _scoreboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Scoreboard created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
