defmodule ExampleAppWeb.InvoiceController do
  use ExampleAppWeb, :controller

  alias ExampleApp.Payments
  alias ExampleApp.Payments.Invoice

  action_fallback ExampleAppWeb.FallbackController

  def index(conn, _params) do
    invoices = Payments.list_invoices()
    render(conn, "index.json", invoices: invoices)
  end

  def create(conn, %{"invoice" => invoice_params}) do
    with {:ok, %Invoice{} = invoice} <- Payments.create_invoice(invoice_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.invoice_path(conn, :show, invoice))
      |> render("show.json", invoice: invoice)
    end
  end

  def show(conn, %{"id" => id}) do
    invoice = Payments.get_invoice!(id)
    render(conn, "show.json", invoice: invoice)
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Payments.get_invoice!(id)

    with {:ok, %Invoice{} = invoice} <- Payments.update_invoice(invoice, invoice_params) do
      render(conn, "show.json", invoice: invoice)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Payments.get_invoice!(id)

    with {:ok, %Invoice{}} <- Payments.delete_invoice(invoice) do
      send_resp(conn, :no_content, "")
    end
  end
end
