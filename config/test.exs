use Mix.Config

config :dwolla,
  http_client: Dwolla.Mock,
  root_uri: "https://test-dwolla.url/",
  client_id: "test_id",
  client_secret: "test_secret"
