defmodule Dwolla.ErrorsTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  setup :verify_on_exit!

  describe "error" do
    test "400 response returns Dwolla.Error with formatted errors" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:error)
        {:ok, httpoison_response(body, 400)}
      end)

      assert {:error, resp} = Dwolla.Customer.update("token", "id", %{})
      assert resp.__struct__ == Dwolla.Errors

      assert resp.errors == [
               %Dwolla.Errors.Error{
                 code: "Required",
                 message: "FirstName is required.",
                 path: "/firstName"
               }
             ]
    end
  end
end
