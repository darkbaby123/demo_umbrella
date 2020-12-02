defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DemoWeb do
    pipe_through :api

    resources "/collectors", CollectorController, except: [:new, :edit]
  end
end
