defmodule Dwolla.BusinessClassificationTest do

  use ExUnit.Case

  import Dwolla.Factory

  alias Dwolla.BusinessClassification
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    Application.put_env(:dwolla, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "business-classifications" do
    test "list/1 requests GET and returns list of Dwolla.BusinessClassification", %{bypass: bypass} do
      body = http_response_body(:business_classification, :list)
      Bypass.expect bypass, fn conn ->
        assert "GET" == conn.method
        Conn.resp(conn, 200, body)
      end

      assert {:ok, resp} = BusinessClassification.list("token")
      assert Enum.count(resp) == 2
      business_classification = Enum.at(resp, 0)
      assert business_classification.__struct__ == Dwolla.BusinessClassification
    end
  end
end
