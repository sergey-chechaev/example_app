defmodule ExampleAppWeb.PaymentController do
  use ExampleAppWeb, :controller

  alias ExampleApp.Payments
  alias ExampleApp.Payments.Payment
  alias Params.External.Payment, as: PaymentParams

  action_fallback ExampleAppWeb.FallbackController

  def index(conn, _params) do
    payment_logs = Payments.list_payment_logs()
    render(conn, "index.json", payment_logs: payment_logs)
  end

  def create(conn, payment_params) do
    with {:ok, prepared_params} <- PaymentParams.prepare(:create, payment_params),
         params <- Map.from_struct(prepared_params),
         {:ok, %Payment{} = payment} <- Payments.create_payment(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.payment_path(conn, :show, payment))
      |> render("show.json", payment: payment)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    render(conn, "show.json", payment: payment)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)

    with {:ok, %Payment{} = payment} <- Payments.update_payment(payment, payment_params) do
      render(conn, "show.json", payment: payment)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)

    with {:ok, %Payment{}} <- Payments.delete_payment(payment) do
      send_resp(conn, :no_content, "")
    end
  end
end
