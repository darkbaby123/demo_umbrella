defmodule DemoService.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DemoService.CollectorLimiter
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DemoService.Supervisor)
  end
end
