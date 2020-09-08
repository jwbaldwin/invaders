defmodule InvadersWeb.HomeLive do
  use InvadersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :choice, :new)}
  end
end
