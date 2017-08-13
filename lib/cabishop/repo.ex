defmodule CabiShop.Repo do
  @moduledoc """
  Interface to manage database operations.
  """

  alias :mnesia, as: Mnesia

  @product ~w(code name price rules)a

  # Client API

  def init do
    nodes = [node()]
    Mnesia.stop()
    Mnesia.create_schema(nodes)
    Mnesia.start()
    Mnesia.create_table(Products, [attributes: @product,
                                  disc_copies: nodes])
  end

  @doc "Retrieves an element from the database, given its type and key"
  def get(type, key) do
    Mnesia.transaction(fn -> Mnesia.read({type, key}) end)
  end

  @doc "Creates a new record in the database"
  def create(record) do
    Mnesia.transaction(fn -> Mnesia.write(record) end)
  end
end
