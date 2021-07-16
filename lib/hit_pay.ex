defmodule HitPay do
  @moduledoc """
  An Elixir client for HitPay payment gateway (https://hit-pay.com/docs.html)
  """

  alias HitPay.{API, Webhook}

  @doc """
  Create a payment request

  ## Examples

      iex> params = %{
        email: "tan@thekirinlab.com",
        redirect_url: "https://packargo.thekirinlab.com/hitpay/success",
        webhook: "https://packargo.thekirinlab.com/hitpay/webhook",
        amount: "599",
        currency: "SGD"
      }
      iex> HitPay.create_payment_request(params)
  """

  @spec create_payment_request(map) :: {:ok, map} | {:error, any}
  def create_payment_request(params) do
    API.request("/payment-requests", :post, params)
  end

  @doc """
  Get payment status

  ## Examples

      iex> HitPay.get_payment_status("93e61239-4334-42fc-be25-6c221b982699")

  """

  @spec get_payment_status(binary()) :: {:ok, map} | {:error, any}
  def get_payment_status(request_id) do
    API.request("/payment-requests/#{request_id}", :get)
  end

  @doc """
  Delete a payment request

  ## Examples

      iex> HitPay.delete_payment_request("93e61239-4334-42fc-be25-6c221b982699")

  """

  @spec delete_payment_request(binary()) :: {:ok, map} | {:error, any}
  def delete_payment_request(request_id) do
    API.request("/payment-requests/#{request_id}", :delete)
  end

  @doc """
  Verify a webhook

  ## Examples

      iex> %{
        "amount" => "35.00",
        "currency" => "SGD",
        "hmac" => "8ae5832ebc8ff5e794815e06b99cb7593dfa3e7b9e5f027f19e9af7f8442a55f",
        "payment_id" => "93e85e66-7579-4144-b478-dedc79054385",
        "payment_request_id" => "93e85e4f-101c-4947-bd93-e6392423c3d2",
        "phone" => "",
        "reference_number" => "FWBGCKSA",
        "status" => "completed"
      } |> HitPay.verify_webhook?()

  """

  @spec verify_webhook?(map) :: boolean()
  def verify_webhook?(params) do
    Webhook.verify_webhook?(params)
  end
end
