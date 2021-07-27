defmodule HitPay.Config do
  @moduledoc """
  Utility that handles interaction with the application's configuration
  """

  @default_environment if Mix.env() == "production", do: "production", else: "sandbox"

  @doc """
  In config.exs your implicit or expicit configuration is:
      config ex_:crowdin, json_library: Poison # defaults to Jason but can be configured to Poison
  """
  @spec json_library() :: module
  def json_library do
    resolve(:json_library, Jason)
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
    resolve(:api_key)
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
    resolve(:salt)
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
    resolve(:environment) || @default_environment
  end

  @doc """
  Resolves the given key from the application's configuration returning the
  wrapped expanded value. If the value was a function it get's evaluated, if
  the value is a touple of three elements it gets applied.
  """
  @spec resolve(atom, any) :: any
  def resolve(key, default \\ nil)

  def resolve(key, default) when is_atom(key) do
    Application.get_env(:hit_pay, key, default)
    |> expand_value()
  end

  def resolve(key, _) do
    raise(
      ArgumentError,
      message: "#{__MODULE__} expected key '#{key}' to be an atom"
    )
  end

  defp expand_value({:system, env})
       when is_binary(env) do
    System.get_env(env)
  end

  defp expand_value({module, function, args})
       when is_atom(function) and is_list(args) do
    apply(module, function, args)
  end

  defp expand_value(value) when is_function(value) do
    value.()
  end

  defp expand_value(value), do: value
end
