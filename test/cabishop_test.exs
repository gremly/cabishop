defmodule CabiShopTest do
  use ExUnit.Case
  doctest CabiShop

  alias CabiShop.{Checkout, Factory, Product}

  alias :mnesia, as: Mnesia

  describe "checkout process" do
    setup do
      Factory.build_voucher()
      |> Product.create()

      Factory.build_mug()
      |> Product.create()

      Factory.build_tshirt()
      |> Product.create()

      {:ok, order} = Checkout.start()

      on_exit fn ->
        Mnesia.clear_table(Products)
      end

      {:ok, %{order: order}}
    end

    test "success simple checkout process", %{order: order} do
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "MUG")
      assert Checkout.total(order) == 32.50
    end

    test "success checkout with voucher discount", %{order: order} do
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "VOUCHER")
      assert Checkout.total(order) == 25.00
    end

    test "success checkout with tshirt discount", %{order: order} do
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "TSHIRT")
      assert Checkout.total(order) == 81.00
    end

    test "success tshirt and voucher discount", %{order: order} do
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "VOUCHER")
      Checkout.scan(order, "MUG")
      Checkout.scan(order, "TSHIRT")
      Checkout.scan(order, "TSHIRT")
      assert Checkout.total(order) == 74.50
    end
  end
end
