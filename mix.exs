defmodule Gumroad.MixProject do
  use Mix.Project

  @source_url "https://github.com/alexpls/gumroad_elixir"

  def project do
    [
      app: :gumroad,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Package

      package: [
        maintainers: ["Alex Plescan"],
        files: ~w(.formatter.exs mix.exs README.md lib),
        links: %{"GitHub" => @source_url}
      ],

      # Docs
      name: "gumroad_elixir",
      source_url: @source_url,
      source_ref: "master",
      homepage_url: @source_url,
      docs: [
        main: "Gumroad",
        extras: ["README.md"],
        groups_for_modules: [
          Clients: [
            Gumroad.Client,
            Gumroad.Client.Live,
            Gumroad.Client.Mock
          ],
          Resources: [
            Gumroad.Product,
            Gumroad.ResourceSubscription,
            Gumroad.Sale,
            Gumroad.Subscriber
          ],
          Testing: [
            Gumroad.Testing,
            Gumroad.Testing.Fixtures
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
