defmodule DemoService.Collectors.Collector do
  use Ecto.Schema

  schema "collectors" do
    field :amount, :integer
    field :curr_amount, :integer

    timestamps type: :naive_datetime_usec
  end
end
