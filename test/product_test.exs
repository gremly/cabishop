defmodule CabiShop.ProductTest do
  use ExUnit.Case 

  alias CabiShop.{Factory, Product}

  describe "Product repository management API" do
    test "product creation success" do
      voucher = Factory.build_voucher()
      assert :ok = Product.create(voucher)
      assert %Product{code: "VOUCHER"} = Product.get(voucher.code)
    end
  end
end
