defmodule ExampleApp.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @tax_percent 0.1

  schema "payment_logs" do
    field :bonus, :decimal
    field :comment, :string
    field :operation_type, Ecto.Enum, values: [:refill, :withdrawal]
    field :pay_period_from, :utc_datetime
    field :pay_period_to, :utc_datetime
    field :status, Ecto.Enum, values: [:initial, :processed, :rejected], default: :initial
    field :sum, :decimal
    field :tax, :decimal

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:sum, :bonus, :tax, :operation_type, :status, :comment, :pay_period_from, :pay_period_to])
    |> validate_required([:sum, :bonus, :tax, :operation_type, :status, :pay_period_from, :pay_period_to])
  end

  def calculate_bonus(sum) do
    sum = Decimal.new(sum) |> Decimal.to_float()
    case sum do
      n when n >= 100 ->
        2
      _ ->
        0
    end
  end

  def calculate_tax(sum) do
    sum = Decimal.new(sum) |> Decimal.to_float()
    sum * @tax_percent
  end
end
