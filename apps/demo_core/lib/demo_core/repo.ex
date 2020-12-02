defmodule DemoCore.Repo do
  use Ecto.Repo,
    otp_app: :demo_core,
    adapter: Ecto.Adapters.Postgres
end
