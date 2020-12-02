defmodule Demo.CollectorsTest do
  use Demo.DataCase

  alias Demo.Collectors

  describe "collectors" do
    alias Demo.Collectors.Collector

    @valid_attrs %{amount: 42, curr_amount: 42, name: "some name"}
    @update_attrs %{amount: 43, curr_amount: 43, name: "some updated name"}
    @invalid_attrs %{amount: nil, curr_amount: nil, name: nil}

    def collector_fixture(attrs \\ %{}) do
      {:ok, collector} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collectors.create_collector()

      collector
    end

    test "list_collectors/0 returns all collectors" do
      collector = collector_fixture()
      assert Collectors.list_collectors() == [collector]
    end

    test "get_collector!/1 returns the collector with given id" do
      collector = collector_fixture()
      assert Collectors.get_collector!(collector.id) == collector
    end

    test "create_collector/1 with valid data creates a collector" do
      assert {:ok, %Collector{} = collector} = Collectors.create_collector(@valid_attrs)
      assert collector.amount == 42
      assert collector.curr_amount == 42
      assert collector.name == "some name"
    end

    test "create_collector/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collectors.create_collector(@invalid_attrs)
    end

    test "update_collector/2 with valid data updates the collector" do
      collector = collector_fixture()

      assert {:ok, %Collector{} = collector} =
               Collectors.update_collector(collector, @update_attrs)

      assert collector.amount == 43
      assert collector.curr_amount == 43
      assert collector.name == "some updated name"
    end

    test "update_collector/2 with invalid data returns error changeset" do
      collector = collector_fixture()
      assert {:error, %Ecto.Changeset{}} = Collectors.update_collector(collector, @invalid_attrs)
      assert collector == Collectors.get_collector!(collector.id)
    end

    test "delete_collector/1 deletes the collector" do
      collector = collector_fixture()
      assert {:ok, %Collector{}} = Collectors.delete_collector(collector)
      assert_raise Ecto.NoResultsError, fn -> Collectors.get_collector!(collector.id) end
    end

    test "change_collector/1 returns a collector changeset" do
      collector = collector_fixture()
      assert %Ecto.Changeset{} = Collectors.change_collector(collector)
    end
  end
end
