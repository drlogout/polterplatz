defmodule PolterplatzWeb.FestivalLive.Page do
  use PolterplatzWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    dbg(slug)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  # @impl true
  # def render(assigns) do
  #   ~H"""
  #   <div>...</div>
  #   """
  # end

  defp page_title(_), do: "Edit Festival"
end
