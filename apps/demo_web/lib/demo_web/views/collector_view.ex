defmodule DemoWeb.CollectorView do
  use DemoWeb, :view
  alias DemoWeb.CollectorView

  def render("index.json", %{collectors: collectors}) do
    %{data: render_many(collectors, CollectorView, "collector.json")}
  end

  def render("show.json", %{collector: collector}) do
    %{data: render_one(collector, CollectorView, "collector.json")}
  end

  def render("collector.json", %{collector: collector}) do
    %{
      id: collector.id,
      name: collector.name,
      amount: collector.amount,
      curr_amount: collector.curr_amount
    }
  end
end
