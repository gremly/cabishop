defmodule CabiShop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias CabiShop.Repo

  def start(_type, _args) do

    # Ensure to initialize the database
    Repo.init()

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: CabiShop.Worker.start_link(arg)
      # {CabiShop.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CabiShop.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
