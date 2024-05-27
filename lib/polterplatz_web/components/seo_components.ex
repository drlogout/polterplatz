defmodule PolterplatzWeb.SEOComponents do
  use Phoenix.Component
  alias Polterplatz.Directus.Image

  attr :globals, :map, required: true
  attr :seo, :map, default: %{}
  attr :page_title, :string, default: ""

  def seo(assigns) do
    ~H"""
    <.title globals={@globals} page_title={@page_title} seo={@seo} />
    <.description seo={@seo} />
    <.open_graph globals={@globals} page_title={@page_title} seo={@seo} />
    <.no_index_no_follow seo={@seo} />
    <.cannonical_url seo={@seo} />
    """
  end

  attr :globals, :map, required: true
  attr :seo, :map, default: %{}
  attr :page_title, :string, default: ""

  def title(assigns) do
    ~H"""
    <title>
      <%= _title(@globals, @page_title, @seo) %>
    </title>
    """
  end

  defp _title(_globals, _page_title, %{"title" => title}) when is_binary(title) do
    title
  end

  defp _title(globals, page_title, _seo) do
    "#{page_title} #{globals["title_separator"] || "·"} #{globals["site_title"]}"
  end

  attr :seo, :map, default: %{}

  def description(assigns) do
    ~H"""
    <meta :if={@seo["meta_description"]} name="description" content={@seo["meta_description"]} />
    """
  end

  attr :globals, :map, required: true
  attr :seo, :map, default: %{}
  attr :page_title, :string, default: ""

  def open_graph(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn ->
        _title(
          assigns.globals,
          assigns.page_title,
          assigns.seo
        )
      end)

    ~H"""
    <meta property="og:site_name" content={@globals["site_title"]} />
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

  attr :seo, :map, default: %{}

  def no_index_no_follow(assigns) do
    ~H"""
    <%= if @seo["no_index"] && @seo["no_follow"] do %>
      <meta name="robots" content="noindex, nofollow" />
    <% end %>
    <%= if @seo["no_nofollow"] do %>
      <meta name="robots" content="nofollow" />
    <% end %>
    <%= if @seo["no_noindex"] do %>
      <meta name="robots" content="noindex" />
    <% end %>
    """
  end

  def cannonical_url(assigns) do
    ~H"""
    <%= if @seo["cannonical"] == "entry" do %>
      <link rel="canonical" href={@seo["permalink"]} />
    <% end %>
    """
  end
end
