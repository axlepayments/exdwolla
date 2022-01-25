defmodule Dwolla.TokenTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  setup :verify_on_exit!

  describe "token" do
    test "get/1 requests POST and returns Dwolla.Token" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:token)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Dwolla.Token.get()
      assert resp.__struct__ == Dwolla.Token
      refute resp.access_token == nil
      refute resp.expires_in == nil
      refute resp.token_type == nil
    end

    test "get/1 requests POST and returns HTTPoison.Error" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        {:error, httpoison_error(:timeout)}
      end)

      assert {:error, %HTTPoison.Error{}} = Dwolla.Token.get()
    end
  end
end
