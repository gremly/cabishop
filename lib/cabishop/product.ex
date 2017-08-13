defmodule CabiShop.Product do
  @moduledoc """
  Product definition structure and management
  functions.
  """

  defstruct [:code, :name, :price, :rules]

  alias CabiShop.Repo

  @doc "Creates a new product into the database"
  def create(%__MODULE__{} = product) do
    {Products, product.code, product.name, product.price, product.rules}
    |> Repo.create()
    |> elem(1)
  end

  @doc "Retrieves a product from the database given its code"
  def get(code) do
    case Repo.get(Products, code) do
      {:atomic, [{Products, code, name, price, rules}]} ->
        %__MODULE__{code: code, name: name, price: price, rules: rules}
      _ -> nil
    end
  end
end
