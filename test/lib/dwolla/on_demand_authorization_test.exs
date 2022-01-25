defmodule Dwolla.OnDemandAuthorizationTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.OnDemandAuthorization

  setup :verify_on_exit!

  describe "on-demand-authorizations" do
    test "create/1 requests POST and returns Dwolla.OnDemandAuthorization" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:on_demand_authorization, :create)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, on_demand_authorization} = OnDemandAuthorization.create("token")
      assert on_demand_authorization.__struct__ == Dwolla.OnDemandAuthorization
    end
  end
end
