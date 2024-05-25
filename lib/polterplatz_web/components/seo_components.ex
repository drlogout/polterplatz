defmodule PolterplatzWeb.SEOComponents do
  use Phoenix.Component
  alias Polterplatz.Directus.Image

  attr :globals, :map, required: true
  attr :seo, :map, default: %{}
  attr :page_title, :string, default: ""

  attr :title, :string, required: true, doc: "The page title."
  attr :prefix, :string, default: nil, doc: "A prefix added before the content of `inner_block`."
  attr :suffix, :string, default: nil, doc: "A suffix added after the content of `inner_block`."

  def title(assigns) do
    ~H"""
    <title data-prefix={@prefix} data-suffix={@suffix}>
      <%= _title(@prefix, @title, @suffix) |> HtmlEntities.encode() %>
    </title>
    """
  end

  defp _title(prefix, inner_block, suffix) do
    "#{prefix}#{inner_block}#{suffix}"
  end

  attr :seo, :map, default: %{}

  def description(assigns) do
    ~H"""
    <meta :if={@seo["meta_description"]} name="description" content={@seo["meta_description"]} />
    """
  end

  def open_graph(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn ->
        _title(
          assigns.globals["site_title_prefix"],
          assigns.page_title,
          assigns.globals["site_title_suffix"]
        )
      end)

    ~H"""
    <meta property="og:site_name" content={@globals["title"]} />
    <meta property="og:type" content="website" />
    <meta property="og:locale" content={@globals["locale"]} />
    <meta property="og:url" content={@seo["permalink"] || "/"} />
    <meta
      property="og:title"
      content={@seo["title"] || @title |> HtmlEntities.encode() |> String.trim()}
    />
    <meta
      :if={@seo["meta_description"]}
      property="og:description"
      content={@seo["meta_description"] |> HtmlEntities.encode()}
    />
    <meta
      property="og:image"
      content={
        Image.get_image_url(@seo["og_image"]["id"],
          width: 1200,
          height: 630,
          fit: "contain",
          format: "auto"
        )
        |> Phoenix.HTML.raw()
      }
    />
    """
  end
end
