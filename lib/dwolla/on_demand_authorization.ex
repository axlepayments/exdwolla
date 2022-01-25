defmodule Dwolla.OnDemandAuthorization do
  @moduledoc """
  Functions for `on-demand-authorizations` endpoint
  """

  alias Dwolla.Utils

  defstruct id: nil, body_text: nil, button_text: nil

  @type t :: %__MODULE__{
          id: String.t(),
          body_text: String.t(),
          button_text: String.t()
        }

  @type token :: String.t()
  @type error :: HTTPoison.Error.t() | Dwolla.Errors.t() | atom | tuple

  @endpoint "on-demand-authorizations"

  @doc """
  Create on demand authorization
  """
  @spec create(token) :: {:ok, Dwolla.OnDemandAuthorization.t()} | {:error, error}
  def create(token) do
    endpoint = @endpoint

    Dwolla.make_request_with_token(:post, endpoint, token)
    |> Utils.handle_resp(:on_demand_authorization)
  end
end
