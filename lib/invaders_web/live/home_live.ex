defmodule InvadersWeb.HomeLive do
  use InvadersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :music, false)}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="w-screen h-screen p-4 text-center" style="background-image: url(<%= Routes.static_path(@socket, "/images/black.png") %> ); background-repeat: repeat;">
      <div class="flex flex-row-reverse w-full h-12 p-4">
        <%= cond do %>
          <% @music -> %>
            <svg phx-click="toggle-music" class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
            </svg>
            <audio loop autoplay>
              <source src="<%= Routes.static_path(@socket, "/music/space-invaders-theme-2002.mp4") %>" type="audio/mpeg">
            </audio>
          <% !@music -> %>
            <svg phx-click="toggle-music" class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" clip-rule="evenodd" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2" />
            </svg>
          <% true -> %>
        <% end %>
      </div>
      <div class="relative flex justify-around w-full h-36 parent">
        <div class="-my-4 slant text-neon-orange">
          <h1 class="my-1 font-black leading-none uppercase text-8xl">Sphxace</h1>
          <h2 class="text-6xl font-black leading-none uppercase">Invaders</h2>
        </div>
        <div class="-my-1.5 slant text-neon-yellow">
          <h1 class="my-1 font-black leading-none uppercase text-8xl">Sphxace</h1>
          <h2 class="text-6xl font-black leading-none uppercase">Invaders</h2>
        </div>
        <div class="my-1 slant text-neon-green">
          <h1 class="my-1 font-black leading-none uppercase text-8xl">Sphxace</h1>
          <h2 class="text-6xl font-black leading-none uppercase">Invaders</h2>
        </div>
      </div>
      <div class="flex flex-col mt-8 text-xl text-white">
        <button phx-click="new" class="m-4 mx-auto cursor-pointer hover:text-neon-greenfocus:text-neon">Play Game</button>
        <span class="m-4 cursor-pointer hover:text-neon-greenfocus:text-green-200">
          <%= live_redirect "Scoreboard", to: Routes.score_index_path(@socket, :index), class: "focus:text-neon" %>
        </span>
      </div>
    </div>
    <style>
    .parent {
      perspective: 100px;
    }
    .slant {
      position: absolute;
      transform: rotateX(-5deg);
      text-shadow: -4px -4px 0 #000, 4px -4px 0 #000, -4px 4px 0 #000, 4px 4px 0 #000;
    }
    </style>
    """
  end

  @impl true
  def handle_event("toggle-music", _params, socket) do
    socket = update(socket, :music, &(!&1))
    {:noreply, socket}
  end

  @impl true
  def handle_event("new", _params, socket) do
    {:noreply, push_redirect(socket, to: "/game")}
  end
end
