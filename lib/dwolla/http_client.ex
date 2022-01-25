defmodule Dwolla.HttpClient do
  @moduledoc """
  An HTTP Client
  """

  use HTTPoison.Base

  defmodule MissingRootUriError do
    defexception message: """
                 The root_uri is required to specify the Dwolla environment to which you are
                 making calls, i.e. development or production. Please configure
                 root_uri in your config.exs file.

                 config :dwolla, root_uri: "https://api-sandbox.dwolla.com/" (development)
                 config :dwolla, root_uri: "https://api.dwolla.com/" (production)
                 """
  end

  def require_root_uri do
    case Application.get_env(:dwolla, :root_uri) || :not_found do
      :not_found -> raise MissingRootUriError
      value -> value
    end
  end

  def process_url(endpoint) do
    require_root_uri() <> endpoint
  end

  def process_response_body(""), do: ""

  def process_response_body(body) do
    case Poison.decode(body) do
      {:ok, parsed_body} -> parsed_body
      {:error, _} -> {:invalid, body}
    end
  end
end
