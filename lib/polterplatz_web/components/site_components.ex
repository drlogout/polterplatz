defmodule PolterplatzWeb.SiteComponents do
  use Phoenix.Component

  alias Polterplatz.Directus.Image
  import PolterplatzWeb.CoreComponents

  def gridpattern(assigns) do
    assigns = assign_new(assigns, :uuid, fn -> Ecto.UUID.generate() end)

    ~H"""
    <svg aria-hidden="true" class="absolute inset-0 w-full h-full">
      <defs>
        <pattern
          id={@uuid}
          width="128"
          height="128"
          patternUnits="userSpaceOnUse"
          x={@x}
          y={@y}
          patternTransform={@pattern_transform}
        >
          <path d="M0 128V.5H128" fill="none" stroke="currentColor" />
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill={"url(##{@uuid})"} />
    </svg>
    """
  end

  attr :size, :string, default: "sm"

  def container(assigns) do
    styles = %{
      "xs" => "mx-auto px-4 sm:px-6 md:max-w-2xl md:px-4 lg:px-2",
      "sm" => "mx-auto px-4 sm:px-6 md:max-w-2xl md:px-4 lg:max-w-4xl lg:px-12",
      "md" => "mx-auto px-4 sm:px-6 md:max-w-2xl md:px-4 lg:max-w-5xl lg:px-8",
      "lg" => "mx-auto px-4 sm:px-6 md:max-w-2xl md:px-4 lg:max-w-7xl lg:px-8"
    }

    assigns =
      assign_new(assigns, :class, fn -> styles[assigns.size] end)

    ~H"""
    <div class={@class}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: nil

  def programm_day(assigns) do
    ~H"""
    <ol
      role="list"
      class={[
        "py-3 text-base tracking-tight divide-y divide-slate-300/30 rounded-2xl bg-slate-50 sm:px-8 sm:py-7",
        @class
      ]}
    >
      <li :for={band <- @bands} class="flex justify-between py-3">
        <div class="w-2/3 text-xl text-slate-900">
          <span class="font-bold">
            <%= band["name"] %>
          </span>
          <a
            :if={band["url"]}
            class="pl-3 text-sm uppercase whitespace-nowrap"
            href={band["url"]}
            target="_blank"
          >
            Info <.icon name="hero-link-mini" class="w-3 h-3" />
          </a>
        </div>
        <span class="w-1/3 font-mono text-right text-slate-400">
          <%= band["time"] %>
        </span>
      </li>
    </ol>
    """
  end

  attr :event, :map, required: true
  attr :class, :string, default: nil

  def programm(assigns) do
    assigns =
      assigns
      |> assign_new(:bands_day1, fn -> assigns.event["bands_day1"] end)
      |> assign_new(:bands_day2, fn -> assigns.event["bands_day2"] end)

    ~H"""
    <ol role="list" class={@class}>
      <li>
        <.h3>
          <.date date={@event["date_day1"]} />
        </.h3>
        <.programm_day :if={@event["bands_day1"]} bands={@event["bands_day1"]} class="mt-4 mb-16" />
      </li>
      <li>
        <.h3>
          <.date date={@event["date_day2"]} />
        </.h3>
      </li>
      <.programm_day :if={@event["bands_day2"]} bands={@event["bands_day2"]} class="mt-4 mb-16" />
    </ol>
    """
  end

  attr :image_id, :string, required: true
  attr :transformations, :list, default: []
  attr :class, :string, default: nil

  def directus_image(assigns) do
    ~H"""
    <img
      src={Image.get_image_url(@image_id, @transformations)}
      alt="Poster"
      class={[
        "object-cover w-full h-auto",
        @class
      ]}
    />
    """
  end

  attr :date, :string, required: true

  def date(assigns) do
    date = Timex.parse!(assigns.date, "{YYYY}-{0M}-{D}")

    assigns =
      assigns
      |> assign(:date, date)

    ~H"""
    <%= Timex.format!(date, "{D}.{0M}.{YYYY}") %>
    """
  end

  def h1(assigns) do
    ~H"""
    <h1 class="text-6xl uppercase font-display sm:text-8xl text-primary drop-shadow-xl">
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  def h2(assigns) do
    ~H"""
    <h2 class="text-5xl uppercase font-display text-secondary drop-shadow-lg">
      <%= render_slot(@inner_block) %>
    </h2>
    """
  end

  def h3(assigns) do
    ~H"""
    <h3 class="text-3xl uppercase font-display text-tertiary drop-shadow-lg">
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  attr :id, :string, required: true
  attr :lat, :string, required: true
  attr :lon, :string, required: true
  attr :zoom, :string, default: "12"
  attr :class, :string, default: nil

  def map(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="Map"
      data-lat={@lat}
      data-lon={@lon}
      data-zoom={@zoom}
      class={[
        "w-full h-96",
        @class
      ]}
    >
    </div>
    """
  end
end
