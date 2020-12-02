defmodule Demo.Collectors.Collector do
  use Demo, :schema

  import Ecto.Changeset

  schema "collectors" do
    field :amount, :integer
    field :curr_amount, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(collector, attrs) do
    collector
    |> cast(attrs, [:name, :amount, :curr_amount])
    |> validate_required([:name, :amount, :curr_amount])
  end
end
