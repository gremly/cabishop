defmodule CabiShop.Discount do
  @moduledoc """ 
  This module allows evaluation of discount rules.

  Each discount rule should be defined as a Map.

    %{rulename: %{parameter: value....}}

  Currently just two discount rules are supported.

  * Bulk discount: This rule evaluates if there is a minimum
    quantity and apply a percentual discount to the product price.

    For example: %{bulk: %{qty: 3, discount: 0.1} applies the 10% of
    discount if the 3 or more products are bought.

  * Pay x get y: This rule allows to pay a number of items and give
    a quantity o items for free.

    For example: %{payx: %{pay: 1, get: 2}} defines a 2-per-1 promotion.
  """

  alias CabiShop.Product

  # Client API

  @doc """
  This is the entry point to apply discount rules defined for products.

  Recieves as parameters the product definition and the quantity of products
  to be bought.

  As result returns the price for the product quantity with the accurate discount
  applied.
  """
  def apply(%Product{price: price, rules: rules}, quantity) do
    do_apply(rules, price, quantity)
  end

  # Internal functions

  defp do_apply(%{bulk: %{qty: qty, discount: dsc}}, price, quantity)
    when qty <= quantity
  do
    (price * (1 - dsc)) * quantity
  end
  defp do_apply(%{payx: %{pay: paid, get: free}}, price, quantity)
    when free <= quantity
  do
    ((div(quantity, free) * paid) + rem(quantity, free)) * price
  end
  defp do_apply(_, price, quantity), do: price * quantity
end
