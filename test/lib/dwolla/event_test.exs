defmodule Dwolla.EventTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.Event

  setup :verify_on_exit!

  describe "events" do
    test "list/3 requests GET and returns list of Dwolla.Event" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:event, :list)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Event.list("token")
      assert Enum.count(resp) == 2
      event = List.first(resp)
      assert event.__struct__ == Dwolla.Event
    end

    test "list/3 sets only limit query string parameter" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, url, _, _, _ ->
        assert url =~ "limit=50"
        body = http_response_body(:event, :list)
        {:ok, httpoison_response(body)}
      end)

      Event.list("token", 50)
    end

    test "list/3 sets limit and offset query string parameters" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, url, _, _, _ ->
        assert url =~ "limit=50&offset=100"
        body = http_response_body(:event, :list)
        {:ok, httpoison_response(body)}
      end)

      Event.list("token", 50, 100)
    end

    test "get/2 requests GET and returns Dwolla.Event" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:event, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Event.get("token", "id")
      assert resp.__struct__ == Dwolla.Event
      refute resp.created == nil
      refute resp.id == nil
      refute resp.resource_id == nil
      refute resp.topic == nil
    end
  end
end
