defmodule Qapp.Repo do
  use Ecto.Repo,
    otp_app: :qapp,
    adapter: Ecto.Adapters.Postgres
end
