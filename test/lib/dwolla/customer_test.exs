defmodule Dwolla.CustomerTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.Customer

  setup :verify_on_exit!

  describe "customer" do
    test "create_unverified/2 requests POST and returns new id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:customer)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        first_name: "Will",
        last_name: "Gilman",
        email: "will@example.com",
        ip_address: "10.0.0.1"
      }

      assert {:ok, resp} = Customer.create_unverified("token", params)
      assert resp.id == "b2cf497a-b315-497e-95b7-d1238288f8cb"
    end

    test "create_unverified/2 returns error on incorrect parameters" do
      assert {:error, resp} = Customer.create_unverified("token", %{})
      assert resp == :invalid_parameters
    end

    test "create_verified/2 requests POST and returns new id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:customer)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        first_name: "Cary",
        last_name: "Grant",
        email: "tocatchathief@example.com",
        ip_address: "10.0.0.1",
        type: "personal",
        address1: "19218 Hollywood Blvd",
        city: "Los Angeles",
        state: "CA",
        postal_code: "90028",
        date_of_birth: "1904-01-18",
        ssn: "1234",
        phone: "1234567890"
      }

      assert {:ok, resp} = Customer.create_verified("token", params)
      assert resp.id == "b2cf497a-b315-497e-95b7-d1238288f8cb"
    end

    test "create_verified/2 returns error on incorrect parameters" do
      assert {:error, resp} = Customer.create_verified("token", %{})
      assert resp == :invalid_parameters
    end

    test "verify/3 requests POST and returns Dwolla.Customer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:customer, :update)
        {:ok, httpoison_response(body)}
      end)

      params = %{
        first_name: "Will",
        last_name: "Gilman",
        email: "will@example.com",
        type: "personal",
        address1: "2340 Chicago St",
        address2: "Apt 3",
        city: "Bodega Bay",
        state: "CA",
        postal_code: "94923",
        date_of_birth: "1990-03-14",
        ssn: "4321",
        phone: "0987654321"
      }

      assert {:ok, resp} = Customer.verify("token", "id", params)
      assert resp.__struct__ == Dwolla.Customer
      assert resp.status == "verified"
    end

    test "verify/3 returns error on incorrect parameters" do
      assert {:error, resp} = Customer.verify("token", "id", %{})
      assert resp == :invalid_parameters
    end

    test "suspend/2 requests POST and returns Dwolla.Customer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:customer, :suspend)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.suspend("token", "id")
      assert resp.__struct__ == Dwolla.Customer
      assert resp.status == "suspended"
    end

    test "get/2 requests GET and returns Dwolla.Customer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:customer, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.get("token", "id")
      assert resp.__struct__ == Dwolla.Customer
      refute resp.id == nil
      refute resp.first_name == nil
      refute resp.last_name == nil
      refute resp.email == nil
      refute resp.type == nil
      refute resp.status == nil
      refute resp.created == nil
      refute resp.address1 == nil
      refute resp.city == nil
      refute resp.phone == nil
      refute resp.postal_code == nil
      refute resp.state == nil
      refute resp.verify_beneficial_ownership == nil
      refute resp.certify_beneficial_ownership == nil
    end

    test "update/3 requests POST and returns Dwolla.Customer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:customer, :update)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.update("token", "id", %{})
      assert resp.__struct__ == Dwolla.Customer
    end

    test "search/2 requests GET and returns list of Dwolla.Customer" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, url, _, _, _ ->
        assert url =~ "search=some%40email.com"
        body = http_response_body(:customer, :search)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.search("token", %{search: "some@email.com"})
      assert Enum.count(resp) == 1
      customer = Enum.at(resp, 0)
      assert customer.__struct__ == Dwolla.Customer
    end

    test "create_funding_source/3 requests POST and returns id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:funding_source)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        routing_number: "114923756",
        account_number: "123456788",
        type: "checking",
        name: "Big Ben's Checking Account"
      }

      assert {:ok, resp} = Customer.create_funding_source("token", "id", params)
      assert resp.id == "e8b4d511-805d-4e91-bfb4-670cd9583a18"
    end

    test "list_funding_sources/3 requests GET and returns list of Dwolla.FundingSource" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:funding_source, :list)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.list_funding_sources("token", "id")
      assert Enum.count(resp) == 4
      funding_source = Enum.at(resp, 0)
      assert funding_source.__struct__ == Dwolla.FundingSource
    end

    test "list_funding_sources/3 sets removed query string parameter" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, url, _, _, _ ->
        assert url =~ "removed=false"
        body = http_response_body(:funding_source, :list)
        {:ok, httpoison_response(body)}
      end)

      Customer.list_funding_sources("token", "id", false)
    end

    test "search_transfers/2 requests GET and return list of Dwolla.Transfer" do
      end_date = Date.utc_today() |> Date.to_iso8601()

      Dwolla.Mock
      |> expect(:request, 1, fn :get, url, _, _, _ ->
        assert url =~ "endDate=#{end_date}"
        body = http_response_body(:transfer, :search)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.search_transfers("token", "id", %{end_date: end_date})
      assert Enum.empty?(resp)
    end

    test "search_transfers/2 returns list when params are omitted" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:transfer, :search)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.search_transfers("token", "id")
      assert Enum.empty?(resp)
    end

    test "create_beneficial_owner/3 requests POST and returns id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:beneficial_owner)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        first_name: "John",
        last_name: "Smith",
        ssn: "000-00-0000",
        date_of_birth: "1900-01-01",
        address: %{
          address1: "1 Main St.",
          city: "New York",
          state_province_region: "NY",
          postal_code: "10019",
          country: "US"
        }
      }

      assert {:ok, resp} = Customer.create_beneficial_owner("token", "id", params)
      assert resp.id == "f73b92a2-71d7-4449-85db-a419dbc2a6d3"
    end

    test "list_beneficial_owners/3 requests GET and returns list of Dwolla.BeneficialOwner" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:beneficial_owner, :list)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Customer.list_beneficial_owners("token", "id")
      assert Enum.count(resp) == 1
      beneficial_owner = Enum.at(resp, 0)
      assert beneficial_owner.__struct__ == Dwolla.BeneficialOwner
    end
  end
end
