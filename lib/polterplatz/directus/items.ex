defmodule Polterplatz.Directus.Items do
  def read(collection_name) do
    url(collection_name)
    |> do_request
  end

  defp url(collection_name) do
    "#{Application.get_env(:polterplatz, :directus_url)}/items/#{collection_name}"
  end

  defp do_request(url) do
    Req.get!(url, cache: false).body["data"]
    |> dbg
  end
end
