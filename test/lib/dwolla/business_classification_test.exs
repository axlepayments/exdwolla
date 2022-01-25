defmodule Dwolla.BusinessClassificationTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.BusinessClassification

  setup :verify_on_exit!

  describe "business-classifications" do
    test "list/1 requests GET and returns list of Dwolla.BusinessClassification" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:business_classification, :list)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = BusinessClassification.list("token")
      assert Enum.count(resp) == 2
      business_classification = Enum.at(resp, 0)
      assert business_classification.__struct__ == Dwolla.BusinessClassification
    end
  end
end
