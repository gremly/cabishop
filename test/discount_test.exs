defmodule CabiShop.DiscountTest do
  use ExUnit.Case, async: true

  alias CabiShop.{Discount, Factory}

  describe "Evaluate and apply discount and promotion rules for products" do

    test "succeed applying discount on bulk purchases" do
      tshirt = Factory.build_tshirt(%{bulk: %{qty: 3, discount: 0.05}})
      assert Discount.apply(tshirt, 5) == 95.00
    end

    test "succeed applying 3-for-2 promotions" do
      voucher = Factory.build_voucher(%{payx: %{pay: 2, get: 3}})
      assert Discount.apply(voucher, 5) == 20.00
    end

    test "succeed applying 3-for-1 promotions including low quantities" do
      voucher = Factory.build_voucher(%{payx: %{pay: 1, get: 3}})
      assert Discount.apply(voucher, 5) == 15.00
      assert Discount.apply(voucher, 4) == 10.00
      assert Discount.apply(voucher, 3) ==  5.00
      assert Discount.apply(voucher, 2) == 10.00
      assert Discount.apply(voucher, 1) ==  5.00
    end
  end
end
