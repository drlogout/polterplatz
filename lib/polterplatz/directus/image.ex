defmodule Polterplatz.Directus.Image do
  def get_image_url(image_id) do
    base_url = Application.get_env(:polterplatz, :directus_url)

    URI.parse(base_url)
    |> URI.append_path(Path.join("/assets", image_id))
    |> URI.to_string()
  end
end
