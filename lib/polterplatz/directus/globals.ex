defmodule Polterplatz.Directus.Globals do
  import Plug.Conn

  def get_globals(conn, _opts) do
    globals = get_globals()

    conn
    |> assign(:globals, globals)
    |> assign(:page_title_suffix, " · #{globals["title"]}")
    |> assign(:page_description, globals["description"])
  end

  def on_mount(:get_globals, _params, _session, socket) do
    globals = get_globals()

    socket =
      socket
      |> Phoenix.Component.assign(:globals, globals)
      |> Phoenix.Component.assign(:page_title_suffix, " · #{globals["title"]}")
      |> Phoenix.Component.assign(:page_description, globals["description"])

    {:cont, socket}
  end

  defp get_globals do
    data =
      Polterplatz.Directus.query("""
        query {
          globals {
            title
            description
          }
        }
      """)

    data["globals"]
  end
end
