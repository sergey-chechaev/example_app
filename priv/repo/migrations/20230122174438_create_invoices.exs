defmodule ExampleApp.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :from, :string
      add :bill_to, :string
      add :amount, :decimal
      add :tax, :decimal

      timestamps()
    end
  end
end
