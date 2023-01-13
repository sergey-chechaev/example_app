defmodule ExampleAppWeb.InvoiceView do
  use ExampleAppWeb, :view
  alias ExampleAppWeb.InvoiceView

  def render("index.json", %{invoices: invoices}) do
    %{data: render_many(invoices, InvoiceView, "invoice.json")}
  end

  def render("show.json", %{invoice: invoice}) do
    %{data: render_one(invoice, InvoiceView, "invoice.json")}
  end

  def render("invoice.json", %{invoice: invoice}) do
    %{
      id: invoice.id,
      from: invoice.from,
      bill_to: invoice.bill_to,
      amount: invoice.amount,
      tax: invoice.tax
    }
  end
end
