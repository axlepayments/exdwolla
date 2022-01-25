defmodule Dwolla.BusinessClassification do
  @moduledoc """
  Functions for `business-classifications` endpoint
  """

  alias Dwolla.Utils

  defstruct id: nil, name: nil

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  @type token :: String.t()
  @type error :: HTTPoison.Error.t() | Dwolla.Errors.t() | atom | tuple

  @endpoint "business-classifications"

  @doc """
  List business classifications
  """
  @spec list(token) :: {:ok, [Dwolla.BusinessClassification.t()]} | {:error, error}
  def list(token) do
    endpoint = @endpoint

    Dwolla.make_request_with_token(:get, endpoint, token)
    |> Utils.handle_resp(:business_classification)
  end
end
