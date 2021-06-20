defmodule ElixWebhookProcessor.Application do
  @moduledoc "OTP App spec for WebhookProcessor"

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ElixWebhookProcessor.Endpoint,
        options: [port: Application.get_env(:elix_webhook_processor, :port)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixWebhookProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
