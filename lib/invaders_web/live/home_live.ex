defmodule InvadersWeb.HomeLive do
  use InvadersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :music, false)}
  end

  def render(assigns) do
    ~L"""
     <div class="w-screen h-screen p-4 text-center bg-black">
      <div class="h-12 flex-row-reverse w-full flex">
        <%= cond do %>
          <% @music -> %>
            <svg phx-click="toggle-music" class="text-white w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
            </svg>
            <audio loop autoplay>
              <source src="<%= Routes.static_path(@socket, "/music/space-invaders-theme-2002.mp4") %>" type="audio/mpeg">
            </audio>
          <% !@music -> %>
            <svg phx-click="toggle-music" class="text-white w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" clip-rule="evenodd" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2" />
            </svg>
          <% true -> %>
        <% end %>
      </div>
      <h1 class="mt-8 font-black leading-none text-white uppercase text-8xl">Start</h1>
      <h2 style="color: green;" class="text-6xl font-black leading-none uppercase">Game</h2>
      <div class="flex flex-col justify-center text-white m-4">
      <button phx-click="new" class="m-4 cursor-pointer hover:text-green-400 focus:text-green-400">Play Game</button>
        <button phx-click="scoreboard"class="m-4 cursor-pointer hover:text-green-400 focus:text-green-400">Score board</button>
      </div>
    </div>
    """
  end

  def handle_event("toggle-music", _params, socket) do
    socket = update(socket, :music, &(!&1))
    {:noreply, socket}
  end

  def handle_event("new", _params, socket) do
    socket = update(socket, :music, &(!&1))
    {:noreply, socket}
  end
end
