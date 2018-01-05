defmodule DriveWealth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :drivewealth_api,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      # Docs
      name: "DriveWealth API",
      source_url: "https://github.com/mbenatti/drivewealth_api",
      homepage_url: "https://github.com/mbenatti/drivewealth_api/README.md"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
     {:poison, "~> 3.0"},
     {:tesla, "~> 0.10.0"},
     {:hackney, "~> 1.10"},
     {:credo, "~> 0.8", only: :dev},
     {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp package do
    [maintainers: ["Marcos Benatti Lauer"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mbenatti/drivewealth_api"},
     files: ~w(mix.exs README.md lib)]
  end

  defp description do
    """
    DriveWealth API in Elixir (http://developer.drivewealth.com)
    """
  end
end
