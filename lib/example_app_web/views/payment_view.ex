defmodule ExampleAppWeb.PaymentView do
  use ExampleAppWeb, :view
  alias ExampleAppWeb.PaymentView

  def render("index.json", %{payment_logs: payment_logs}) do
    %{data: render_many(payment_logs, PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{
      id: payment.id,
      sum: payment.sum,
      bonus: payment.bonus,
      tax: payment.tax,
      operation_type: payment.operation_type,
      status: payment.status,
      comment: payment.comment,
      pay_period_from: payment.pay_period_from,
      pay_period_to: payment.pay_period_to
    }
  end
end
