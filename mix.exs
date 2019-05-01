defmodule RankingVoteApp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ranking_vote_app,
      version: "0.0.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RankingVoteApp.Application, []},
      extra_applications: [:logger, :runtime_tools, :goth]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix            , "~> 1.4.4"          },
      {:phoenix_pubsub     , "~> 1.0"            },
      {:phoenix_html       , "~> 2.10"           },
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext            , "~> 0.11"           },
      {:plug_cowboy        , "~> 2.0"            },
      {:distillery         , "~> 2.0"            },
      {:diplomat           , "~> 0.2"            },
      {:croma              , "~> 0.9.3"          },
      {:cors_plug          , "~> 1.5"            },
    ]
  end
end
