defmodule Polterplatz.Repo do
  use Ecto.Repo,
    otp_app: :polterplatz,
    adapter: Ecto.Adapters.Postgres
end
