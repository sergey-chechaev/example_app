defmodule ExampleApp.PaymentsTest do
  use ExampleApp.DataCase

  alias ExampleApp.Payments

  describe "payment_logs" do
    alias ExampleApp.Payments.Payment

    import ExampleApp.PaymentsFixtures

    @invalid_attrs %{bonus: nil, comment: nil, operation_type: nil, pay_period_from: nil, pay_period_to: nil, status: nil, sum: nil, tax: nil}

    test "list_payment_logs/0 returns all payment_logs" do
      payment = payment_fixture()
      assert Payments.list_payment_logs() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      valid_attrs = %{bonus: "120.5", comment: "some comment", operation_type: :refill, pay_period_from: ~U[2022-11-19 19:05:00Z], pay_period_to: ~U[2022-11-19 19:05:00Z], status: :initial, sum: "120.5", tax: "120.5"}

      assert {:ok, %Payment{} = payment} = Payments.create_payment(valid_attrs)
      assert payment.bonus == Decimal.new("120.5")
      assert payment.comment == "some comment"
      assert payment.operation_type == :refill
      assert payment.pay_period_from == ~U[2022-11-19 19:05:00Z]
      assert payment.pay_period_to == ~U[2022-11-19 19:05:00Z]
      assert payment.status == :initial
      assert payment.sum == Decimal.new("120.5")
      assert payment.tax == Decimal.new("120.5")
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      update_attrs = %{bonus: "456.7", comment: "some updated comment", operation_type: :withdrawal, pay_period_from: ~U[2022-11-20 19:05:00Z], pay_period_to: ~U[2022-11-20 19:05:00Z], status: :processed, sum: "456.7", tax: "456.7"}

      assert {:ok, %Payment{} = payment} = Payments.update_payment(payment, update_attrs)
      assert payment.bonus == Decimal.new("456.7")
      assert payment.comment == "some updated comment"
      assert payment.operation_type == :withdrawal
      assert payment.pay_period_from == ~U[2022-11-20 19:05:00Z]
      assert payment.pay_period_to == ~U[2022-11-20 19:05:00Z]
      assert payment.status == :processed
      assert payment.sum == Decimal.new("456.7")
      assert payment.tax == Decimal.new("456.7")
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end

  describe "invoices" do
    alias ExampleApp.Payments.Invoice

    import ExampleApp.PaymentsFixtures

    @invalid_attrs %{amount: nil, bill_to: nil, from: nil, tax: nil}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Payments.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Payments.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{amount: "120.5", bill_to: "some bill_to", from: "some from", tax: "120.5"}

      assert {:ok, %Invoice{} = invoice} = Payments.create_invoice(valid_attrs)
      assert invoice.amount == Decimal.new("120.5")
      assert invoice.bill_to == "some bill_to"
      assert invoice.from == "some from"
      assert invoice.tax == Decimal.new("120.5")
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      update_attrs = %{amount: "456.7", bill_to: "some updated bill_to", from: "some updated from", tax: "456.7"}

      assert {:ok, %Invoice{} = invoice} = Payments.update_invoice(invoice, update_attrs)
      assert invoice.amount == Decimal.new("456.7")
      assert invoice.bill_to == "some updated bill_to"
      assert invoice.from == "some updated from"
      assert invoice.tax == Decimal.new("456.7")
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_invoice(invoice, @invalid_attrs)
      assert invoice == Payments.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Payments.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Payments.change_invoice(invoice)
    end
  end
end
