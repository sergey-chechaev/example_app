defmodule Services.PaymentExecutor do
  @moduledoc """
    This service creates the payment, an invoice and
    sends an email to the manager and calculates statistics
  """

  @doc ~S"""
  Execute service

  ## Examples when data is correct

    iex> Services.PaymentExecutor.call(%{sum: 100, operation_type: :refill, pay_period_from: "2023-01-01 00:00:00", pay_period_to: "2023-01-20 00:00:00", bonus: 10, tax: 10})
    {:ok, %Services.PaymentExecutor{}}

  ## Example when data is not correct
    iex> Services.PaymentExecutor.call()
    {:error, %Services.PaymentExecutor{}}
  """
  require Logger
  alias Ecto.Enum
  alias ExampleApp.Payments
  alias ExampleApp.Payments.{Payment, Invoice}
  alias Services.ErrorBuilder

  defstruct payment_params: nil,
            payment: nil,
            invoice: nil,
            valid?: true,
            error: false

  @type payment_executor_struct_t :: %__MODULE__{}
  @spec call(
          payment_params ::
            Map.t(
              sum: float(),
              bonus: float(),
              tax: float(),
              operation_type: Enum.values(Payment, :operation_type),
              pay_period_from: UtcDate.t(),
              pay_period_to: UtcDate.t()
            )
        ) ::
          Tuple.t(:error, Ecto.Changeset.t())
          | Tuple.t(:ok, payment_executor_struct_t())

  def call(payment_params) do
    payment_params
    |> build_struct()
    |> create_payment()
    |> create_invoice()
    |> send_email()
    |> execute_statistic_worker()
    |> transform_result()
  end

  defp build_struct(payment_params) do
    %__MODULE__{payment_params: payment_params}
  end

  defp create_payment(%__MODULE__{valid?: false} = struct), do: struct

  defp create_payment(%__MODULE__{payment_params: payment_params} = struct) do
    case Payments.create_payment(payment_params) do
      {:ok, %Payment{} = payment} ->
        %__MODULE__{struct | payment: payment}

      {:error, error} ->
        %__MODULE__{
          struct
          | valid?: false,
            error: {:create_payment, "can't create Payment #{inspect(error)}"}
        }
    end
  end

  defp create_invoice(%__MODULE__{valid?: false} = struct), do: struct

  defp create_invoice(%__MODULE__{payment: %{sum: amount, tax: tax}} = struct) do
    invoice_params = %{
      amount: amount,
      tax: tax,
      from: "example app",
      bill_to: "other example app"
    }

    case Payments.create_invoice(invoice_params) do
      {:ok, %Invoice{} = invoice} ->
        struct

      {:error, error} ->
        %__MODULE__{
          struct
          | valid?: false,
            error: {:create_invoice, "can't create Invoice #{inspect(error)}"}
        }
    end
  end

  defp send_email(%__MODULE__{valid?: false} = struct), do: struct

  defp send_email(struct) do
    IO.puts("Send an email to the manager")
    struct
  end

  defp execute_statistic_worker(%__MODULE__{valid?: false} = struct), do: struct

  defp execute_statistic_worker(struct) do
    IO.puts("Execute the worker for calculate statistics")
    struct
  end

  defp transform_result(%__MODULE__{valid?: false, error: error}) do
    {:error, ErrorBuilder.call(error, __MODULE__)}
  end

  defp transform_result(struct) do
    {:ok, struct}
  end
end
