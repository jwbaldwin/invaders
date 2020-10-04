defmodule InvadersWeb.ScoreLive.FormComponent do
  use InvadersWeb, :live_component

  alias Invaders.Scoreboard

  @impl true
  def update(%{score: score} = assigns, socket) do
    changeset = Scoreboard.change_score(score)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"score" => score_params}, socket) do
    changeset =
      socket.assigns.score
      |> Scoreboard.change_score(score_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"score" => score_params}, socket) do
    save_score(socket, socket.assigns.action, score_params)
  end

  defp save_score(socket, :new, score_params) do
    IO.inspect(score_params)

    case Scoreboard.create_score(score_params) do
      {:ok, _score} ->
        {:noreply,
         socket
         |> put_flash(:info, "Score created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
