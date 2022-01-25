defmodule Dwolla.ClientTokenTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.ClientToken

  setup :verify_on_exit!

  describe "client-tokens" do
    test "create/2 requests POST and returns Dwolla.ClientToken" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:client_token, :create)
        {:ok, httpoison_response(body)}
      end)

      params = %{
        _links: %{
          customer: %{
            href: "https://api-uat.dwolla.com/customers/customer-id"
          }
        },
        action: "beneficialowners.create"
      }

      assert {:ok, resp} = ClientToken.create("token", params)
      assert resp.__struct__ == Dwolla.ClientToken
      refute resp.token == nil
    end
  end
end
