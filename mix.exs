defmodule HitPay.MixProject do
  use Mix.Project

  def project do
    [
      app: :hit_pay,
      version: "0.2.3",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.0"},
      {:plug_crypto, "~> 1.0"},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  defp description do
    """
    A HitPay client for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Vu Minh Tan"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/thekirinlab/hit_pay"}
    ]
  end
end
