defmodule Dwolla.ClientToken do
  @moduledoc """
  Functions for "client-tokens" endpoint.
  """

  alias Dwolla.Utils

  defstruct token: nil

  @type t :: %__MODULE__{token: String.t}
  @type token :: String.t
  @type params :: %{required(atom) => String.t | integer}
  @type error :: HTTPoison.Error.t | Dwolla.Errors.t

  @endpoint "client-tokens"

  @doc """
  Creates a client token.

  Parameters
  ```
  %{
    _links: %{
      customer: %{
        href: "https://api-sandbox.dwolla.com/customers/..."
      }
    },
    action: "beneficialowners.create"
  }
  ```
  """
  @spec create(token, params) :: {:ok, Dwolla.ClientToken.t} | {:error, error}
  def create(token, params) do
    endpoint = @endpoint
    Dwolla.make_request_with_token(:post, endpoint, token, params, %{})
    |> Utils.handle_resp(:client_token)
  end
end
