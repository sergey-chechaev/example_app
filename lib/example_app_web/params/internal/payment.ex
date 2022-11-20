defmodule Params.Internal.Payment do
  @moduledoc """
    Resolves validation params for internal payment creation
  """
  use ExampleAppWeb, :params

  alias ExampleApp.Payments.Payment
  alias Ecto.Enum

  @required [:operation_type, :sum, :bonus, :tax, :comment]

  embedded_schema do
    field :bonus, :decimal
    field :comment, :string
    field :operation_type, Enum, values: Enum.values(Payment, :operation_type)
    field :status, Enum, values: Enum.values(Payment, :status)
    field :pay_period_from, :utc_datetime
    field :pay_period_to, :utc_datetime
    field :sum, :decimal
    field :tax, :decimal
  end

  def prepare(:create, params) do
    params
    |> cast_start_pay_period()
    |> cast_end_pay_period()
    |> fetch_status()
    |> create_changeset()
    |> apply_action(:insert)
  end

  defp cast_start_pay_period(params) do
    pay_period_from =
      Timex.today()
      |> Timex.to_datetime()

    Map.put(params, "pay_period_from", pay_period_from)
  end

  def cast_end_pay_period(params) do
    pay_period_to =
      Timex.today()
      |> Timex.end_of_month()
      |> Timex.to_datetime()

    Map.put(params, "pay_period_to", pay_period_to)
  end

  def fetch_status(params) do
    {:ok, status} = fetch(Payment, "status")
    Map.put(params, "status", status)
  end

  defp create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [
      :operation_type,
      :status,
      :sum,
      :bonus,
      :pay_period_from,
      :pay_period_to,
      :tax,
      :comment
    ])
    |> validate_required(@required)
  end
end
