defmodule Dwolla.OnDemandAuthorizationTest do

  use ExUnit.Case

  import Dwolla.Factory

  alias Dwolla.OnDemandAuthorization
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    Application.put_env(:dwolla, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "on-demand-authorizations" do
    test "create/1 requests POST and returns Dwolla.OnDemandAuthorization", %{bypass: bypass} do
      body = http_response_body(:on_demand_authorization, :create)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Conn.resp(conn, 200, body)
      end

      assert {:ok, on_demand_authorization} = OnDemandAuthorization.create("token")
      assert on_demand_authorization.__struct__ == Dwolla.OnDemandAuthorization
    end
  end
end
