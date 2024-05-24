defmodule Polterplatz.Directus do
  def query(query) do
    base_url = Application.get_env(:polterplatz, :directus_url)

    Neuron.Config.set(url: "#{base_url}/graphql")

    {:ok, resp} = Neuron.query(query)
    resp.body["data"]
  end
end
