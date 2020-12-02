defmodule Demo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Demo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Demo.PubSub}
      # Start a worker by calling: Demo.Worker.start_link(arg)
      # {Demo.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Demo.Supervisor)
  end
end
