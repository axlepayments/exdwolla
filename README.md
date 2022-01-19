# Dwolla

Elixir Library for Dwolla

This package was originally forked then extended from the `dwolla_elixir` package (https://hex.pm/packages/dwolla_elixir)

Supported endpoints:

- [ ] Accounts
- [x] Beneficial Owners
- [x] Business Classifications
- [x] Client Tokens
- [x] Customers
- [x] Documents
- [x] Funding Sources
- [x] On Demand Authorizations
- [x] Transfers
- [ ] Mass Payments
- [x] Events
- [x] Webhook Subscriptions
- [x] Webhooks

[Dwolla Documentation](https://developers.dwolla.com/api-reference)

## Usage

Add to your dependencies in `mix.exs`.

```elixir
def deps do
  [{:dwolla, "~> 1.0", hex: :exdwolla}]
end
```

## Configuration

All calls to Dwolla require a valid access token. To fetch/refresh the access token
you need to add your Dwolla client_id and client_secret to your config.

```elixir
config :dwolla,
  root_uri: "https://api.dwolla.com/",
  client_id: "your_client_id",
  client_secret: "your_client_secret"
```

The `root_uri` is configured by `mix` environment by default. You
can override them in your configuration.

- `dev` - sandbox
- `prod` - production

## Tests and Style

This library uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Dwolla.

Run tests using `mix test`.

Before making pull requests, run the coverage and style checks.

```elixir
mix coveralls
mix credo
```
