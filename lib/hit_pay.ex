defmodule HitPay do
  @moduledoc """
  An Elixir client for HitPay payment gateway (https://hit-pay.com/docs.html)
  """

  alias HitPay.API

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
  def create_payment_request(params) do
    API.request("/payment-requests", :post, params)
  end

  @doc """
  Get payment status

  ## Examples

      iex> HitPay.get_payment_status("93e61239-4334-42fc-be25-6c221b982699")

  """

  def get_payment_status(request_id) do
    API.request("/payment-requests/#{request_id}", :get, %{})
  end

  @doc """
  Delete a payment request

  ## Examples

      iex> HitPay.delete_payment_request("93e61239-4334-42fc-be25-6c221b982699")

  """

  def delete_payment_request(request_id) do
    API.request("/payment-requests/#{request_id}", :delete, %{})
  end
end
