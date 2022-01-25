defmodule Dwolla.TransferTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.Transfer

  setup :verify_on_exit!

  describe "transfer" do
    test "initiate/2 requests POST and returns a new id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:transfer)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        _links: %{
          source: %{
            href: "https://api-uat.dwolla.com/funding-sources/sender-id"
          },
          destination: %{
            href: "https://api-uat.dwolla.com/funding-sources/recip-id"
          }
        },
        amount: %{
          currency: "USD",
          value: "25.60"
        }
      }

      assert {:ok, resp} = Transfer.initiate("token", params)
      assert resp.id == "494b6269-d909-e711-80ee-0aa34a9b2388"
    end

    test "get/2 requests GET and returns Dwolla.Transfer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:transfer, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Transfer.get("token", "id")
      assert resp.__struct__ == Dwolla.Transfer
      refute resp.id == nil
      refute resp.created == nil
      refute resp.status == nil
      refute resp.amount.value == nil
      refute resp.amount.currency == nil
      refute resp.metadata == nil
      assert resp.source_resource == "accounts"
      assert resp.source_resource_id == "fc81fee0-1520-4949-bc2d-73e4e11fddd9"
      assert resp.source_funding_source_id == "70c99528-285d-4de5-9ece-6d9b8f5cb1a4"
      assert resp.dest_resource == "customers"
      assert resp.dest_resource_id == "df1eb2aa-3d75-48a1-b882-425b579a85dc"
      assert resp.can_cancel == true
    end

    test "get_transfer_failure_reason/2 requests GET and returns Dwolla.Transfer.Failure" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:transfer, :failure)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Transfer.get_transfer_failure_reason("token", "id")
      assert resp.__struct__ == Dwolla.Transfer.Failure
      refute resp.code == nil
      refute resp.description == nil
    end

    test "cancel/2 requests POST and returns Dwolla.Transfer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:transfer, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Transfer.cancel("token", "id")
      assert resp.__struct__ == Dwolla.Transfer
    end
  end
end
