defmodule CabiShop.Factory do
  @moduledoc """
  This module wraps the functions related to create
  data for testing purposes.
  """

  alias CabiShop.Product
  
  def build_voucher(rules \\ %{payx: %{pay: 1, get: 2}}) do
    %Product{
      code: "VOUCHER",
      name: "Cabify Voucher",
      price: 5.00,
      rules: rules 
    }
  end

  def build_mug(rules \\ %{}) do
    %Product{
      code: "MUG",
      name: "Cabify Coffee Mug",
      price: 7.50,
      rules: rules 
    }
  end

  def build_tshirt(rules \\ %{bulk: %{qty: 3, discount: 0.05}}) do
    %Product{
      code: "TSHIRT",
      name: "Cabify T-Shirt",
      price: 20.00,
      rules: rules 
    }
  end
end
