defmodule DemoWeb.CollectorController do
  use DemoWeb, :controller

  alias Demo.Collectors
  alias Demo.Collectors.Collector

  action_fallback DemoWeb.FallbackController

  def index(conn, _params) do
    collectors = Collectors.list_collectors()
    render(conn, "index.json", collectors: collectors)
  end

  def create(conn, %{"collector" => collector_params}) do
    with {:ok, %Collector{} = collector} <- Collectors.create_collector(collector_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.collector_path(conn, :show, collector))
      |> render("show.json", collector: collector)
    end
  end

  def show(conn, %{"id" => id}) do
    collector = Collectors.get_collector!(id)
    render(conn, "show.json", collector: collector)
  end

  def update(conn, %{"id" => id, "collector" => collector_params}) do
    collector = Collectors.get_collector!(id)

    with {:ok, %Collector{} = collector} <-
           Collectors.update_collector(collector, collector_params) do
      render(conn, "show.json", collector: collector)
    end
  end

  def delete(conn, %{"id" => id}) do
    collector = Collectors.get_collector!(id)

    with {:ok, %Collector{}} <- Collectors.delete_collector(collector) do
      send_resp(conn, :no_content, "")
    end
  end
end
