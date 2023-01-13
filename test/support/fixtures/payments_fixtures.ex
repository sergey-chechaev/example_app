defmodule ExampleApp.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExampleApp.Payments` context.
  """

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        bonus: "120.5",
        comment: "some comment",
        operation_type: :refill,
        pay_period_from: ~U[2022-11-19 19:05:00Z],
        pay_period_to: ~U[2022-11-19 19:05:00Z],
        status: :initial,
        sum: "120.5",
        tax: "120.5"
      })
      |> ExampleApp.Payments.create_payment()

    payment
  end

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        bill_to: "some bill_to",
        from: "some from",
        tax: "120.5"
      })
      |> ExampleApp.Payments.create_invoice()

    invoice
  end
end
