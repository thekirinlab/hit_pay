defmodule HitPay.Request do
  @moduledoc """
  Utilities to send request to Crowdin API v2
  """

  alias HTTPoison.{Error, Response}
  require Logger

  alias HitPay.Config

  @callback request(String.t(), String.t(), any(), list, list) :: {:ok, map} | {:error, any()}
  def request(method, req_url, body, req_headers, opts) do
    Logger.debug(req_url)

    HTTPoison.request(method, req_url, body, req_headers, opts)
    |> handle_response()
  end

  defp handle_response({:ok, %Response{body: body, status_code: code}})
       when code in 200..299 do
    Logger.debug("body: #{inspect(body)}")

    {:ok, decode_body(body)}
  end

  defp handle_response({:ok, %Response{body: body, status_code: _}}) do
    Logger.error(inspect(body))
    {:error, decode_body(body)}
  end

  defp handle_response({:error, %Error{} = error}),
    do: {:error, error}

  defp decode_body(""), do: ""

  defp decode_body(body) do
    Config.json_library().decode!(body)
  end
end
