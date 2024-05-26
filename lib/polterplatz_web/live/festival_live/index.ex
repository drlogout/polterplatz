defmodule PolterplatzWeb.FestivalLive.Index do
  alias Polterplatz.Directus
  use PolterplatzWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    resp =
      Directus.query("""
      query {
        events(filter: {show_on_homepage: {_eq: true}}) {
          year
          date_day1
          date_day2
          bands_day1
          bands_day2
          poster {
            id
          }
          seo {
            title
            meta_description
            og_image {
              id
            }
          }
        }
      }
      """)

    event =
      resp["events"]
      |> List.first()

    socket
    |> assign(:seo, event["seo"])
    |> assign(:event, event)
  end

  def date_range(event) do
    day1 = Timex.parse!(event["date_day1"], "{YYYY}-{0M}-{D}")
    day2 = Timex.parse!(event["date_day2"], "{YYYY}-{0M}-{D}")

    Timex.format!(day1, "{D}.–") <> Timex.format!(day2, "{D}.{0M}.{YYYY}")
  end
end
