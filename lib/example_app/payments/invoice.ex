defmodule ExampleApp.Payments.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :amount, :decimal
    field :bill_to, :string
    field :from, :string
    field :tax, :decimal

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:from, :bill_to, :amount, :tax])
    |> validate_required([:from, :bill_to, :amount, :tax])
  end
end
