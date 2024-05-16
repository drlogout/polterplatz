defmodule Polterplatz.Directus do
  alias Polterplatz.Directus.Items

  def globals do
    Items.read("globals")
  end
end
