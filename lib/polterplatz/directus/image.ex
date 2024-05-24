defmodule Polterplatz.Directus.Image do
  def get_image_url(image_id, transformations \\ []) do
    base_url = Application.get_env(:polterplatz, :directus_url)

    query = URI.encode_query(transformations)

    URI.parse(base_url)
    |> URI.append_path(Path.join("/assets", image_id))
    |> URI.append_query(query)
    |> URI.to_string()
  end
end
