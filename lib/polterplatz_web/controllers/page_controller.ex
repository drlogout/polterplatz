defmodule PolterplatzWeb.PageController do
  use PolterplatzWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> assign(:page_title, "Home")
    |> render(:home, layout: false)
  end
end
