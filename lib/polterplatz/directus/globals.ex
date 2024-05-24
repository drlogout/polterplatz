defmodule Polterplatz.Directus.Globals do
  import Plug.Conn

  def get_globals(conn, _opts) do
    conn
    |> assign(:globals, get_globals())

    # |> assign(:page_title_suffix, " · #{globals["title"]}")
    # |> assign(:page_description, globals["description"])
  end

  def on_mount(:get_globals, _params, _session, socket) do
    socket =
      Phoenix.Component.assign_new(socket, :globals, fn ->
        get_globals()
      end)

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
