defmodule Dwolla.BeneficialOwner do
  @moduledoc """
  Functions for `beneficial-owners` endpoint
  """

  alias Dwolla.Utils

  defstruct id: nil, first_name: nil, last_name: nil, address: nil, verification_status: nil

  @type t :: %__MODULE__{
    id: String.t,
    first_name: String.t,
    last_name: String.t,
    address: %{
      address1: String.t,
      address2: String.t,
      address3: String.t,
      city: String.t,
      state_province_region: String.t,
      postal_code: String.t,
      country: String.t
    },
    verification_status: String.t
  }

  @type token :: String.t
  @type id :: String.t
  @type params :: %{required(atom) => String.t | integer}
  @type error :: HTTPoison.Error.t | Dwolla.Errors.t | atom | tuple

  @endpoint "beneficial-owners"

  @doc """
  Gets a beneficial owner by id.
  """
  @spec get(token, id) :: {:ok, Dwolla.BeneficialOwner.t} | {:error, error}
  def get(token, id) do
    endpoint = @endpoint <> "/#{id}"
    Dwolla.make_request_with_token(:get, endpoint, token)
    |> Utils.handle_resp(:beneficial_owner)
  end

  @doc """
  Deletes a beneficial owner.
  """
  @spec delete(token, id) ::
    {:ok, Dwolla.BeneficialOwner.t} | {:error, error}
  def delete(token, id) do
    endpoint = @endpoint <> "/#{id}"
    Dwolla.make_request_with_token(:delete, endpoint, token)
    |> Utils.handle_resp(:beneficial_owner)
  end
end
