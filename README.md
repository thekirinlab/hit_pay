# HitPay

An Elixir client for HitPay Payment Gateway

## Installation

Add to your `mix.exs` the following lines

```elixir
def deps do
  [
    {:hit_pay, "~> 0.2.2"}
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

## Using the API

### To create a payment request

```elixir
params = %{
  email: "tan@thekirinlab.com",
  redirect_url: "https://packargo.thekirinlab.com/hitpay/success",
  webhook: "https://packargo.thekirinlab.com/hitpay/webhook",
  amount: "599",
  currency: "SGD"
}
HitPay.create_payment_request(params)
```

### To get payment status

```elixir
request_id = "93e61239-4334-42fc-be25-6c221b982699"
HitPay.get_payment_status(request_id)
```
### To delete a payment request

```elixir
request_id = "93e61239-4334-42fc-be25-6c221b982699"
HitPay.delete_payment_request(request_id)
```

### To verify webhook

```elixir
%{
  "amount" => "35.00",
  "currency" => "SGD",
  "hmac" => "8ae5832ebc8ff5e794815e06b99cb7593dfa3e7b9e5f027f19e9af7f8442a55f",
  "payment_id" => "93e85e66-7579-4144-b478-dedc79054385",
  "payment_request_id" => "93e85e4f-101c-4947-bd93-e6392423c3d2",
  "phone" => "",
  "reference_number" => "FWBGCKSA",
  "status" => "completed"
} |> HitPay.verify_webhook?()
```

## Documentation

More info can be found at [https://hexdocs.pm/hit_pay](https://hexdocs.pm/hit_pay).

