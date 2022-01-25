# Dwolla

An Elixir Library for Dwolla

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

This library uses [mox](https://github.com/dashbitco/mox) to simulate HTTP responses from Dwolla.

Run tests using `mix test`.

Before making pull requests, run the coverage and style checks.

```elixir
mix coveralls
mix format
mix credo
```

## Credit

This library was originally forked then extended from the `dwolla_elixir` package (https://hex.pm/packages/dwolla_elixir).

The decision to create a new, separate Elixir library for Dwolla, rather than contribute back to the original library was driven primarily by our own internal use-case for this library. 

The biggest reason for creating a new libary was our need for replacing the testing library Bypass with Mox. We use Mox in the rest of our applications and did not want to pull in Bypass as well, in order to fully simulate HTTP responses from Dwolla. Instead, we replaced Bypass in this library with Mox in order to allow for better and more complete testing against the Dwolla library from within our other application.

Along with the above, we added several new endpoints and modified some existing endpoints to better suite our needs for this library. 

Because of these, we decided it was better to treat this as a brand new Elixir library. 

A large credit goes to `wfgilman` and the other contributors on the original `dwolla_elixir` library.
