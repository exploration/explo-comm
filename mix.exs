defmodule ExploComm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :explo_comm,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"}
    ]
  end
end
