defmodule Dwolla.WebhookTest do
  use ExUnit.Case

  import Dwolla.Factory
  import Dwolla.TestUtils
  import Mox

  alias Dwolla.Webhook

  setup :verify_on_exit!

  describe "webhook" do
    test "get/2 requests GET and returns Dwolla.Webhook" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:webhook, :get)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Webhook.get("token", "id")
      assert resp.__struct__ == Dwolla.Webhook
      refute resp.id == nil
      refute resp.topic == nil
      refute resp.account_id == nil
      refute resp.event_id == nil
      refute resp.subscription_id == nil
      assert Enum.count(resp.attempts) == 1
      attempt = List.first(resp.attempts)
      assert attempt.__struct__ == Dwolla.Webhook.Attempt
      refute attempt.id == nil
      assert attempt.request.__struct__ == Dwolla.Webhook.Attempt.Request
      refute attempt.request.timestamp == nil
      refute attempt.request.url == nil
      refute attempt.request.headers == []
      refute attempt.request.body == nil
      assert attempt.response.__struct__ == Dwolla.Webhook.Attempt.Response
      refute attempt.response.timestamp == nil
      refute attempt.response.headers == []
      refute attempt.response.status_code == nil
      refute attempt.response.body == nil
    end

    test "retry/2 requests POST and returns a new id" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        header = http_response_header(:webhook)
        {:ok, httpoison_response("", 201, [header])}
      end)

      assert {:ok, resp} = Webhook.retry("token", "id")
      assert resp.id == "5aa27a0f-cf99-418d-a3ee-67c0ff99a494"
    end

    test "list_retries/2 requests GET and returns list of Dwolla.Retry" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        body = http_response_body(:webhook, :retries)
        {:ok, httpoison_response(body)}
      end)

      assert {:ok, resp} = Webhook.list_retries("token", "id")
      assert Enum.count(resp) == 1
      retry = List.first(resp)
      assert retry.__struct__ == Dwolla.Webhook.Retry
      refute retry.id == nil
      refute retry.timestamp == nil
    end
  end
end
