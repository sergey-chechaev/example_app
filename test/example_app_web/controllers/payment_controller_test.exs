defmodule ExampleAppWeb.PaymentControllerTest do
  use ExampleAppWeb.ConnCase

  import ExampleApp.PaymentsFixtures

  alias ExampleApp.Payments.Payment

  @create_attrs %{
    bonus: "120.5",
    comment: "some comment",
    operation_type: :refill,
    pay_period_from: ~U[2022-11-19 19:05:00Z],
    pay_period_to: ~U[2022-11-19 19:05:00Z],
    status: :initial,
    sum: "120.5",
    tax: "120.5"
  }
  @update_attrs %{
    bonus: "456.7",
    comment: "some updated comment",
    operation_type: :withdrawal,
    pay_period_from: ~U[2022-11-20 19:05:00Z],
    pay_period_to: ~U[2022-11-20 19:05:00Z],
    status: :processed,
    sum: "456.7",
    tax: "456.7"
  }
  @invalid_attrs %{bonus: nil, comment: nil, operation_type: nil, pay_period_from: nil, pay_period_to: nil, status: nil, sum: nil, tax: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_logs", %{conn: conn} do
      conn = get(conn, Routes.payment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment" do
    test "renders payment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), payment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.payment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "bonus" => "120.5",
               "comment" => "some comment",
               "operation_type" => "refill",
               "pay_period_from" => "2022-11-19T19:05:00Z",
               "pay_period_to" => "2022-11-19T19:05:00Z",
               "status" => "initial",
               "sum" => "120.5",
               "tax" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), payment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "renders payment when data is valid", %{conn: conn, payment: %Payment{id: id} = payment} do
      conn = put(conn, Routes.payment_path(conn, :update, payment), payment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.payment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "bonus" => "456.7",
               "comment" => "some updated comment",
               "operation_type" => "withdrawal",
               "pay_period_from" => "2022-11-20T19:05:00Z",
               "pay_period_to" => "2022-11-20T19:05:00Z",
               "status" => "processed",
               "sum" => "456.7",
               "tax" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put(conn, Routes.payment_path(conn, :update, payment), payment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete(conn, Routes.payment_path(conn, :delete, payment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.payment_path(conn, :show, payment))
      end
    end
  end

  defp create_payment(_) do
    payment = payment_fixture()
    %{payment: payment}
  end
end
