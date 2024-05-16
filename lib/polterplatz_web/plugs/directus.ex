defmodule PolterplatzWeb.Plugs.Directus do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    globals =
      Polterplatz.Directus.globals()
      |> dbg

    assign(conn, :globals, globals)
  end
end
