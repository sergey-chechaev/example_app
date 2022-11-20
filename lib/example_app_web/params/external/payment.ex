defmodule Params.External.Payment do
  @moduledoc """
    Resolves validation params for external payment creation
  """
  use ExampleAppWeb, :params

  alias ExampleApp.Payments.Payment
  alias Ecto.Enum

  @required [:operation_type, :sum]

  embedded_schema do
    field :bonus, :decimal, default: 0
    field :comment, :string
    field :operation_type, Enum, values: Enum.values(Payment, :operation_type)
    field :status, Enum, values: Enum.values(Payment, :status)
    field :pay_period_from, :utc_datetime
    field :pay_period_to, :utc_datetime
    field :sum, :decimal
    field :tax, :decimal, default: 0
  end

  def prepare(:create, params) do
    params
    |> cast_start_pay_period()
    |> cast_end_pay_period()
    |> maybe_add_bonus_sum()
    |> add_tax()
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

  defp maybe_add_bonus_sum(
         %{
           "operation_type" => "refill",
           "sum" => sum
         } = params
       ) do
    Map.put(params, "bonus", Payment.calculate_bonus(sum))
  end

  defp maybe_add_bonus_sum(params), do: params

  defp add_tax(
         %{
           "operation_type" => "refill",
           "sum" => sum
         } = params
       ) do
    Map.put(params, "tax", Payment.calculate_tax(sum))
  end

  defp add_tax(params), do: params

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
      :tax
    ])
    |> validate_required(@required)
  end
end
