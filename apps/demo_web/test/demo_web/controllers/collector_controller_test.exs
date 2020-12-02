defmodule DemoWeb.CollectorControllerTest do
  use DemoWeb.ConnCase

  alias Demo.Collectors
  alias Demo.Collectors.Collector

  @create_attrs %{
    amount: 42,
    curr_amount: 42,
    name: "some name"
  }
  @update_attrs %{
    amount: 43,
    curr_amount: 43,
    name: "some updated name"
  }
  @invalid_attrs %{amount: nil, curr_amount: nil, name: nil}

  def fixture(:collector) do
    {:ok, collector} = Collectors.create_collector(@create_attrs)
    collector
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all collectors", %{conn: conn} do
      conn = get(conn, Routes.collector_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create collector" do
    test "renders collector when data is valid", %{conn: conn} do
      conn = post(conn, Routes.collector_path(conn, :create), collector: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.collector_path(conn, :show, id))

      assert %{
               "id" => _id,
               "amount" => 42,
               "curr_amount" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.collector_path(conn, :create), collector: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update collector" do
    setup [:create_collector]

    test "renders collector when data is valid", %{
      conn: conn,
      collector: %Collector{id: id} = collector
    } do
      conn = put(conn, Routes.collector_path(conn, :update, collector), collector: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.collector_path(conn, :show, id))

      assert %{
               "id" => _id,
               "amount" => 43,
               "curr_amount" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, collector: collector} do
      conn = put(conn, Routes.collector_path(conn, :update, collector), collector: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete collector" do
    setup [:create_collector]

    test "deletes chosen collector", %{conn: conn, collector: collector} do
      conn = delete(conn, Routes.collector_path(conn, :delete, collector))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.collector_path(conn, :show, collector))
      end
    end
  end

  defp create_collector(_) do
    collector = fixture(:collector)
    %{collector: collector}
  end
end
