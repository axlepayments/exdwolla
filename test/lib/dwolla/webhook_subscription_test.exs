defmodule Dwolla.WebhookSubscriptionTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.WebhookSubscription

  setup :verify_on_exit!

  describe "webhook-subscriptions" do
    test "create/2 requests POST and returns a new id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:webhook_subscription)
        {:ok, httpoison_response("", 201, [header])}
      end)

      params = %{
        url: "https://twopence.co/api/dwolla",
        secret: "s3cret"
      }

      assert {:ok, resp} = WebhookSubscription.create("token", params)
      assert resp.id == "d2b4f94a-e0bf-4ef0-9285-a08efe023a4e"
    end

    test "get/2 requests GET and returns Dwolla.WebhookSubscription" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:webhook_subscription, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = WebhookSubscription.get("token", "id")
      assert resp.__struct__ == Dwolla.WebhookSubscription
      refute resp.id == nil
      refute resp.created == nil
      refute resp.url == nil
      refute resp.paused == nil
    end

    test "pause/2 requests POST and returns Dwolla.WebhookSubscription" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:webhook_subscription, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = WebhookSubscription.pause("token", "id")
      assert resp.__struct__ == Dwolla.WebhookSubscription
    end

    test "resume/2 requests POST and returns Dwolla.WebhookSubscription" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        body = http_response_body(:webhook_subscription, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = WebhookSubscription.resume("token", "id")
      assert resp.__struct__ == Dwolla.WebhookSubscription
    end

    test "list/1 requests GET and returns list of Dwolla.WebhookSubscription" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:webhook_subscription, :list)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = WebhookSubscription.list("token")
      assert Enum.count(resp) == 1
      sub = List.first(resp)
      assert sub.__struct__ == Dwolla.WebhookSubscription
    end

    test "delete/2 requests DELETE and returns Dwolla.WebhookSubscription" do
      Dwolla.Mock
      |> expect(:request, 1, fn :delete, _, _, _, _ ->
        body = http_response_body(:webhook_subscription, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = WebhookSubscription.delete("token", "id")
      assert resp.__struct__ == Dwolla.WebhookSubscription
    end
  end
end
