defmodule Select.Mixfile do
  use Mix.Project

  def project do
    [app: :select,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: "An Elixir library to extract useful data from HTML documents, suitable for web scraping.",
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:mochiweb, "~> 2.12.2"}]
  end

  def package do
    [contributors: ["Utkarsh Kukreti"],
     licenses: ["MIT"],
     links: %{GitHub: "https://github.com/utkarshkukreti/select.ex"}]
  end
end
