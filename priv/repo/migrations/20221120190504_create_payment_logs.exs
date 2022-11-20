defmodule ExampleApp.Repo.Migrations.CreatePaymentLogs do
  use Ecto.Migration

  def change do
    create table(:payment_logs) do
      add :sum, :decimal
      add :bonus, :decimal
      add :tax, :decimal
      add :operation_type, :string
      add :status, :string
      add :comment, :text
      add :pay_period_from, :utc_datetime
      add :pay_period_to, :utc_datetime

      timestamps()
    end
  end
end
