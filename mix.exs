defmodule DriveWealth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :drivewealth_api,
      version: "0.1.0",
      elixir: "~> 1.5",
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
     {:poison, "~> 3.0"},
     {:tesla, "~> 0.10.0"},
     {:hackney, "~> 1.10"},
     {:credo, "~> 0.8", only: [:dev]}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
