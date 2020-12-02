# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :demo,
  ecto_repos: [Demo.Repo]

config :demo_web,
  ecto_repos: [Demo.Repo],
  generators: [context_app: :demo]

# Configures the endpoint
config :demo_web, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eNQ3DQLvW+pK7Tqzkn33LOuZD6483IK7rF7oiiR09lgF0ifjE+j37SkwU2Z4Gg2l",
  render_errors: [view: DemoWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Demo.PubSub,
  live_view: [signing_salt: "9bOxjyHy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
