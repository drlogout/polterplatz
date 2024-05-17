defmodule PolterplatzWeb.Plugs.Directus do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    globals =
      Polterplatz.Directus.globals()
      |> dbg

    conn
    |> assign(:globals, globals)
    |> assign(:page_title_suffix, " · #{globals["title"]}")
    |> assign(:page_description, globals["description"])
  end
end
