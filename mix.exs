defmodule ExploComm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :explo_comm,
      version: "2.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
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
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
