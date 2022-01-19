defmodule Dwolla.BeneficialOwnerTest do

  use ExUnit.Case

  import Dwolla.Factory

  alias Dwolla.BeneficialOwner
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    Application.put_env(:dwolla, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "beneficial-owners" do
    test "get/2 requests GET and returns Dwolla.BeneficialOwner", %{bypass: bypass} do
      body = http_response_body(:beneficial_owner, :get)
      Bypass.expect bypass, fn conn ->
        assert "GET" == conn.method
        Conn.resp(conn, 200, body)
      end

      assert {:ok, resp} = BeneficialOwner.get("token", "id")
      assert resp.__struct__ == Dwolla.BeneficialOwner
      refute resp.id == nil
      refute resp.first_name == nil
      refute resp.last_name == nil
      refute resp.address == nil
      refute resp.verification_status == nil
    end

    test "delete/2 requests DELETE and returns Dwolla.BeneficialOwner", %{bypass: bypass} do
      body = http_response_body(:beneficial_owner, :get)
      Bypass.expect bypass, fn conn ->
        assert "DELETE" == conn.method
        Conn.resp(conn, 200, body)
      end

      assert {:ok, resp} = BeneficialOwner.delete("token", "id")
      assert resp.__struct__ == Dwolla.BeneficialOwner
    end
  end
end
