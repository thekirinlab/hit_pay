defmodule HitPay.API do
  @moduledoc """
  Utilities for interacting with the HitPay API.
  API Doc: https://hit-pay.com/docs.html
  """

  alias HitPay.{Config, Request}

  @production_api_path "https://api.hit-pay.com/v1"
  @sandbox_api_path "https://api.sandbox.hit-pay.com/v1"
  @staging_api_path "https://api.staging.hit-pay.com/v1"

  @type method :: :get | :post | :put | :delete | :patch
  @type headers :: %{String.t() => String.t()} | %{}
  @type body :: iodata() | {:multipart, list()}

  defp api_path do
    environment = Config.environment()

    case environment do
      "production" -> @production_api_path
      "staging" -> @staging_api_path
      _ -> @sandbox_api_path
    end
  end

  @spec add_default_headers(headers) :: headers
  defp add_default_headers(headers) do
    Map.merge(
      %{
        "X-Requested-With": "XMLHttpRequest",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      headers
    )
  end

  @spec add_auth_header(headers) :: headers
  defp add_auth_header(headers) do
    Map.put(headers, "X-BUSINESS-API-KEY", Config.api_key())
  end

  @spec request(String.t(), method, body, headers, list) ::
          {:ok, map} | {:error, Error.t()}
  def request(path, method, body \\ "", headers \\ %{}, opts \\ []) do
    req_url = build_path(path)

    req_headers =
      headers
      |> add_default_headers()
      |> add_auth_header()
      |> Map.to_list()

    encoded_body = encode_body(body, method)

    # @request_module
    Request.request(method, req_url, encoded_body, req_headers, opts)
  end

  # url encode if post, put or patch
  defp encode_body(body, method) do
    if method in [:post, :patch, :put] do
      URI.encode_query(body)
    else
      body
    end
  end

  defp build_path(path) do
    if String.starts_with?(path, "/") do
      "#{api_path()}#{path}"
    else
      "#{api_path()}/#{path}"
    end
  end
end
