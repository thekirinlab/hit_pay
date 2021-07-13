# HitPay

An Elixir client for HitPay Payment Gateway

## Installation

Add to your `mix.exs` the following lines

```elixir
def deps do
  [
    {:hit_pay, "~> 0.2.0"}
  ]
end
```

## Configuration

To use HitPay API, we need to setup a dashboard account and configure api key and salt.

```elixir
config :hit_pay,
  api_key: System.get_env("HIT_PAY_API_KEY"),
  salt: {MyApp.Config, :hit_pay_salt, []},
  environment: "sandbox" # or "production"
```

or

```elixir
config :hit_pay,
  api_key: {:system, "HIT_PAY_API_KEY"},
  salt: {:system, "HIT_PAY_SALT"},
  environment: {:system, "HIT_PAY_ENVIRONMENT"}
```

You can also use the JSON libary of your choice, Jason is used by default

```elixir
config :hit_pay, json_library: Poison
```

## Documentation

Documentation can be found at [https://hexdocs.pm/hit_pay](https://hexdocs.pm/hit_pay).

