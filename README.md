# CabiShop

This is an excericse intended to manage promotions and discounts in virtual
sotre. There is no inventory control, just basic product creation.

## Installation

Elixir 1.5.1 or above is required.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cabishop` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cabishop, "~> 0.1.0"}
  ]
end
```

If there is no need to use this app as library, you can just clone the source code, compile
and start it from an `iex` session.

```
$ git clone https://github.com/gremly/cabishop.git
```

```
$ mix deps.get
```

```
$ mix test
```

```
$ iex -S mix
```

There is another posibility, instead of start it from `iex`, a release could be generated.

```
$ MIX_ENV=<desired_env> mix do clean, compile, release --env=<desired_env>
```

## Usage

### Products management

Before start the checkout process, it is needed to create some products in the store inventory.

Products are defined with the following structure:

```elixir
prd =
  %CabiShop.Product{
    code: "PRODUCTCODE",
    name: "Product Name",
    price: 5.0,
    rules: %{payx: %{get: 2, pay: 1}}
  }
```

To save a product in the database, `new_product/1` function from the main API can be used. Using the
previous `struct` definition, the function usage looks like this:

```elixir
> :ok = CabiShop.new_product(prd)
```

It is possible to get detailed information of a product using `get_product/1`.

```elixir
> CabiShop.new_product("PRODUCTCODE")
```

#### Discount rules

There are two supported discount rules or promotions.

* Discount for buying x quantity: It is known as `bulk` in the application. Defines a rule
  which applies a percentual discount to the price of a product, when the quantity to be bought
  is more than a defined minimum `x`.

  The format to define this rule is the following Map: %{bulk: %{qty: 3, discount: 0.1}}

* Promotion x-for-y: It is known as `payx` in the application. Defines the typical promotion of
  pay `x` quantity of a product and get `y`.

  The format to define this rule is the following Map: %{payx: %{pay: 1, get: 2}}

### Checkout process

As we are working with processes, to start selling products a checkout process should be started:

```elixir
{:ok, co} = CabiShop.start_checkout()
```

If all products were created, they can be added one by one to the current checkout using `scan_product/2`:

```elixir
CabiShop.scan_product(co, "PRODUCTCODE")
```

Finally, the calculation of the total price with discounts included is responsibility of the `total/1` function:

```elixir
CabiShop.total(co)
```


## License

This work is free. Can be redistributed and/or modified under the terms of the MIT License.
