defmodule ExampleAppWeb.External.PaymentController do
  use ExampleAppWeb, :controller

  alias ExampleApp.Payments
  alias ExampleApp.Payments.Payment
  alias Params.External.Payment, as: PaymentParams

  action_fallback ExampleAppWeb.FallbackController

  def create(conn, payment_params) do
    with {:ok, prepared_params} <- PaymentParams.prepare(:create, payment_params),
         params <- Map.from_struct(prepared_params),
         {:ok, %Payment{} = payment} <- Payments.create_payment(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.payment_path(conn, :show, payment))
      |> render(ExampleAppWeb.PaymentView, "show.json", payment: payment)
    end
  end
end
