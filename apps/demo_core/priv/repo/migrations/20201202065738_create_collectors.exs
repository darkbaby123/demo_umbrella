defmodule DemoCore.Repo.Migrations.CreateCollectors do
  use Ecto.Migration

  def change do
    create table("collectors") do
      add :name, :string
      add :amount, :integer
      add :curr_amount, :integer
      timestamps()
    end
  end
end
