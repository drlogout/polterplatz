defmodule Polterplatz.Directus.Globals do
  import Plug.Conn

  def get_globals(conn, _opts) do
    globals = get_globals()

    conn
    |> assign(:globals, globals)
  end

  def on_mount(:get_globals, _params, _session, socket) do
    globals = get_globals()

    socket =
      socket
      |> Phoenix.Component.assign(:globals, globals)

    {:cont, socket}
  end

  defp get_globals do
    data =
      Polterplatz.Directus.query("""
        query {
          globals {
            site_title
            site_description
            site_title_prefix
            site_title_suffix
            locale
          }
        }
      """)

    data["globals"]
  end
end
