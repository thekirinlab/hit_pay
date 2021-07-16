defmodule HitPay.API do
  @moduledoc """
  Utilities for interacting with the HitPay API.
  API Doc: https://hit-pay.com/docs.html
  """

  alias HitPay.{Config, Request}

  @production_api_path "https://api.hit-pay.com/v1"
  @sandbox_api_path "https://api.sandbox.hit-pay.com/v1"
  @staging_api_path "https://api.staging.hit-pay.com/v1"

  @default_environment if Mix.env() == "production", do: "production", else: "sandbox"

  @type method :: :get | :post | :put | :delete | :patch
  @type headers :: %{String.t() => String.t()} | %{}
  @type body :: iodata() | {:multipart, list()}

  @request_module if Mix.env() == :test, do: HitPay.RequestMock, else: Request

  @doc """
  In config.exs your implicit or expicit configuration is:
      config ex_:crowdin, json_library: Poison # defaults to Jason but can be configured to Poison
  """
  @spec json_library() :: module
  def json_library do
    Config.resolve(:json_library, Jason)
  end

  @doc """
  In config.exs, use a string, a function or a tuple:
      config :hit_pay, api_key: System.get_env("HIT_PAY_API_KEY")

  or:
      config :hit_pay, api_key: {:system, "HIT_PAY_API_KEY"}

  or:
      config :hit_pay, api_key: {MyApp.Config, :hit_pay_api_key, []}
  """
  def api_key do
    Config.resolve(:api_key)
  end

  @doc """
  In config.exs, use a string, a function or a tuple:
      config :hit_pay, salt: System.get_env("HIT_PAY_SALT")

  or:
      config :hit_pay, salt: {:system, "HIT_PAY_SALT"}

  or:
      config :hit_pay, salt: {MyApp.Config, :HIT_PAY_SALT, []}
  """
  def salt do
    Config.resolve(:salt)
  end

  @doc """
  If there's no environment config, detect based on environment. sandbox is used for non-production environment.
  In config.exs, use a string, a function or a tuple. Possible environments are "sandbox", "staging", "production"

      config :hit_pay, environment: "sandbox"
  or:

      config :hit_pay, environment: System.get_env("HIT_PAY_ENVIRONMENT")

  or:
      config :hit_pay, environment: {:system, "HIT_PAY_ENVIRONMENT"}

  or:
      config :hit_pay, environment: {MyApp.Config, :HIT_PAY_ENVIRONMENT, []}
  """
  def environment do
    Config.resolve(:environment) || @default_environment
  end

  defp api_path do
    environment = environment()

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
    Map.put(headers, "X-BUSINESS-API-KEY", api_key())
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
    @request_module.request(method, req_url, encoded_body, req_headers, opts)
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
