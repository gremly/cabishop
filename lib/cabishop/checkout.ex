defmodule CabiShop.CheckoutSupervisor do
  @moduledoc """
  Supervises shop orders.

  This supervisor allows to create one process for
  checkout order.
  """
  use Supervisor

  # Client API
  
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Supervisor Callbacks

  def init(_args) do
    children = [{CabiShop.Checkout, restart: :transient}]
    opts = [strategy: :simple_one_for_one]
    Supervisor.init(children, opts)
  end
end

defmodule CabiShop.Checkout do
  @moduledoc """
  This is a process responsible to manage a
  sale, adding products to the cart and
  computing price rules defined by product.
  """
  use GenServer

  alias CabiShop.{Product, Discount}

  @supervisor CabiShop.CheckoutSupervisor

  # Client API

  @doc "Creates a checkout order ready to scan products."
  def start do
    Supervisor.start_child(@supervisor, [])
  end

  @doc "Finishes the checkout and turns off the current server."
  def finish(server) do
    GenServer.cast(server, :finish)
  end

  @doc """
  Allows to add products to the current order.

  It validates if thereis a product identified with
  the given code. If succed returns the atom :ok, otherwise
  returns the atom :product_unavailable.
  """
  def scan(server, code) do
    GenServer.call(server, {:scan, code})
  end

  @doc "Returns the total value of the order with discounts applied."
  def total(server) do
    GenServer.call(server, :total)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  # GenServer callbacks

  def init(_args) do
    {:ok, %{products: Map.new()}}
  end

  def handle_call({:scan, code}, _from, %{products: products} = state) do
    {result, products} = add_product(code, products)
    {:reply, result, %{state| products: products}}
  end
  def handle_call(:total, _from, %{products: products} = state) do
    {:reply, totalize(products), state}
  end

  def handle_cast(:finish, state) do
    {:stop, :normal, state}
  end

  # Internal Functions

  defp add_product(code, products) do
    case product_exists?(code) do
      true ->  {:ok, checkout_product(code, products)}
      false -> {:product_unavailable, products}
    end
  end

  defp checkout_product(code, products) do
    case Map.get(products, code) do
      nil -> Map.put(products, code, 1)
      qty -> Map.put(products, code, qty + 1)
    end
  end

  defp product_exists?(code) do
    Product.get(code) != nil
  end

  defp totalize(products) do
    Enum.reduce(products, 0, fn({code, qty}, acc) ->
      code
      |> Product.get()
      |> Discount.apply(qty)
      |> Kernel.+(acc)
    end)
  end
end
