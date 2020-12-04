defmodule DemoService.Collectors do
  alias DemoCore.Repo
  alias DemoService.Collectors.Collector

  import Ecto.Query

  def get_collector!(id) do
    Repo.get!(Collector, id)
  end

  def update_curr_amount(id, curr_amount) do
    Collector
    |> where(id: ^id)
    |> Repo.update_all(set: [curr_amount: curr_amount])
  end
end
