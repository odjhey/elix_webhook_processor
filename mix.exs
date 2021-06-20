defmodule ElixWebhookProcessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :elix_webhook_processor,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # add releases configuration
      releases: [
        # we can name releases anything, this will be prod's config
        prod: [
          # we'll be deploying to Linux only
          include_executables_for: [:unix],
          # have Mix automatically create a tarball after assembly
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {ElixWebhookProcessor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
