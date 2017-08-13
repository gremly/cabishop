defmodule CabiShop do
  @moduledoc """
  This module is the main entry point to use
  the CabiShop API.

  Here are exposed functions to manage checkout process
  and products in a consistent way.
  """

  alias CabiShop.{Checkout, Product}

  @doc """
  Returns the total price of the current checkout process with all
  promotions and discounts applied for each product.
  """
  defdelegate total(checkout), to: Checkout

  @doc "Starts a new checkout process"
  def start_checkout do
    Checkout.start()
  end

  @doc "Add products to the current checkout process"
  def scan_product(checkout, product) do
    Checkout.scan(checkout, product)
  end

  @doc "Stops the checkout process"
  def finish_checkout(checkout) do
    Checkout.finish(checkout)
  end

  @doc """
  Creates a new product.

  This function recieves as parameter a Product structure which is defined
  as follows:

  %Product{code: "code", name: "name", price: 1.00, rules: %{rule: %{val: a...}}}
  """
  def new_product(%Product{} = product) do
    Product.create(product)
  end

  def get_product(code) do
    Product.get(code)
  end
end
