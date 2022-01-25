defmodule Dwolla.BeneficialOwnerTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.BeneficialOwner

  setup :verify_on_exit!

  describe "beneficial-owners" do
    test "get/2 requests GET and returns Dwolla.BeneficialOwner" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:beneficial_owner, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = BeneficialOwner.get("token", "id")
      assert resp.__struct__ == Dwolla.BeneficialOwner
      refute resp.id == nil
      refute resp.first_name == nil
      refute resp.last_name == nil
      refute resp.address == nil
      refute resp.verification_status == nil
    end

    test "delete/2 requests DELETE and returns Dwolla.BeneficialOwner" do
      Dwolla.Mock
      |> expect(:request, 1, fn :delete, _, _, _, _ ->
        body = http_response_body(:beneficial_owner, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = BeneficialOwner.delete("token", "id")
      assert resp.__struct__ == Dwolla.BeneficialOwner
    end
  end
end
