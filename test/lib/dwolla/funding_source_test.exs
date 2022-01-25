defmodule Dwolla.FundingSourceTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.FundingSource

  setup :verify_on_exit!

  describe "funding-source" do
    test "get/2 requests GET and returns Dwolla.FundingSource" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:funding_source, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = FundingSource.get("token", "id")
      assert resp.__struct__ == Dwolla.FundingSource
      refute resp.id == nil
      refute resp.created == nil
      refute resp.name == nil
      refute resp.removed == nil
      refute resp.status == nil
      refute resp.type == nil
      refute resp.channels == nil
      refute resp.bank_name == nil
    end

    test "update/3 requests POST and returns Dwolla.FundingSource" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:funding_source, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = FundingSource.update_name("token", "id", "My Checking")
      assert resp.__struct__ == Dwolla.FundingSource
    end

    test "remove/2 requests POST and returns Dwolla.FundingSource" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:funding_source, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = FundingSource.remove("token", "id")
      assert resp.__struct__ == Dwolla.FundingSource
    end

    test "balance/2 requests GET and returns Dwolla.FundingSource.Balance" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:balance, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = FundingSource.balance("token", "id")
      assert resp.__struct__ == Dwolla.FundingSource.Balance
    end
  end
end
