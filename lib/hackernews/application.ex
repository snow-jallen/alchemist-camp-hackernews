defmodule Hackernews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Hackernews.Worker.start_link(arg)
      #{Hackernews.Worker, arg}
      {Hackernews.Scheduler, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hackernews.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
