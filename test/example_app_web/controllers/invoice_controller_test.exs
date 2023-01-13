defmodule ExampleAppWeb.InvoiceControllerTest do
  use ExampleAppWeb.ConnCase

  import ExampleApp.PaymentsFixtures

  alias ExampleApp.Payments.Invoice

  @create_attrs %{
    amount: "120.5",
    bill_to: "some bill_to",
    from: "some from",
    tax: "120.5"
  }
  @update_attrs %{
    amount: "456.7",
    bill_to: "some updated bill_to",
    from: "some updated from",
    tax: "456.7"
  }
  @invalid_attrs %{amount: nil, bill_to: nil, from: nil, tax: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all invoices", %{conn: conn} do
      conn = get(conn, Routes.invoice_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create invoice" do
    test "renders invoice when data is valid", %{conn: conn} do
      conn = post(conn, Routes.invoice_path(conn, :create), invoice: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.invoice_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "amount" => "120.5",
               "bill_to" => "some bill_to",
               "from" => "some from",
               "tax" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.invoice_path(conn, :create), invoice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update invoice" do
    setup [:create_invoice]

    test "renders invoice when data is valid", %{conn: conn, invoice: %Invoice{id: id} = invoice} do
      conn = put(conn, Routes.invoice_path(conn, :update, invoice), invoice: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.invoice_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "amount" => "456.7",
               "bill_to" => "some updated bill_to",
               "from" => "some updated from",
               "tax" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
      conn = put(conn, Routes.invoice_path(conn, :update, invoice), invoice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete invoice" do
    setup [:create_invoice]

    test "deletes chosen invoice", %{conn: conn, invoice: invoice} do
      conn = delete(conn, Routes.invoice_path(conn, :delete, invoice))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.invoice_path(conn, :show, invoice))
      end
    end
  end

  defp create_invoice(_) do
    invoice = invoice_fixture()
    %{invoice: invoice}
  end
end
