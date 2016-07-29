# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :poketron,
  ecto_repos: [Poketron.Repo]

# Configures the endpoint
config :poketron, Poketron.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LfoeoRWDEPB9ht0/HEDujxv/SuhtcvqcnoyTh9IqDshGZyZFaa8UAZCAfoIPjZkP",
  render_errors: [view: Poketron.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Poketron.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "71017855936-80ktqai0siimpeved9rrcucrhf1ottt5.apps.googleusercontent.com",
  client_secret: "4DM4CkSkfIgieBcn87jMZea5",
  redirect_uri: "http://localhost:4000"

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
verify_module: Guardian.JWT,  # optional
issuer: "Poketron",
  ttl: { 30, :days },
  verify_issuer: true, # optional
secret_key: "Test_Key",
  serializer:  Poketron.GuardianSerializer

import_config "#{Mix.env}.exs"
