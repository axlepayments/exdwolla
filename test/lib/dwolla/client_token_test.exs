defmodule Dwolla.ClientTokenTest do

  use ExUnit.Case

  import Dwolla.Factory

  alias Dwolla.ClientToken
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    Application.put_env(:dwolla, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "client-tokens" do
    test "create/2 requests POST and returns Dwolla.ClientToken", %{bypass: bypass} do
      body = http_response_body(:client_token, :create)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Conn.resp(conn, 200, body)
      end

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
