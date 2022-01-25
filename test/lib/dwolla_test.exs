defmodule DwollaTest do
  use ExUnit.Case

  import Dwolla.TestUtils
  import Mox

  setup :verify_on_exit!

  describe "dwolla" do
    test "get_cred/0 returns credentials as a map" do
      assert %{client_id: _, client_secret: _} = Dwolla.get_cred()
    end

    test "get_cred/0 raises when client_id is missing" do
      Application.put_env(:dwolla, :client_id, nil)
      assert_raise Dwolla.MissingClientIdError, fn -> Dwolla.get_cred() end
      cleanup_config()
    end

    test "get_cred/0 raises when secret is missing" do
      Application.put_env(:dwolla, :client_secret, nil)
      assert_raise Dwolla.MissingClientSecretError, fn -> Dwolla.get_cred() end
      cleanup_config()
    end

    test "make_request_with_token/3 raises when root_uri is missing" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        raise Dwolla.HttpClient.MissingRootUriError
      end)

      Application.put_env(:dwolla, :root_uri, nil)

      assert_raise Dwolla.HttpClient.MissingRootUriError, fn ->
        Dwolla.make_request_with_token(:get, "any", "token")
      end

      Application.put_env(:dwolla, :root_uri, "https://test-dwolla.url/")
    end

    test "make_request_with_token/3 requests GET returns HTTPoison.Response" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        {:ok, httpoison_response(%{status: "ok"})}
      end)

      assert {:ok, %HTTPoison.Response{}} = Dwolla.make_request_with_token(:get, "any", "token")
    end

    test "make_request_with_token/3 returns error tuple when HTTP call fails" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, _, _ ->
        {:error, httpoison_error(:timeout)}
      end)

      assert {:error, %HTTPoison.Error{}} = Dwolla.make_request_with_token(:get, "any", "token")
    end

    test "make_oauth_token_request/2 merges credentials into request body" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, rb, _, _ ->
        assert "client_id=id&client_secret=shhhh" == rb
        {:ok, httpoison_response(%{status: "ok"})}
      end)

      Dwolla.make_oauth_token_request(%{}, %{client_id: "id", client_secret: "shhhh"})
    end

    test "make_oauth_token_request/2 returns error tuple when HTTP call fails" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, _, _ ->
        {:error, httpoison_error(:timeout)}
      end)

      assert {:error, %HTTPoison.Error{}} =
               Dwolla.make_oauth_token_request(%{}, %{client_id: "id", client_secret: "shhhh"})
    end

    test "make_request_with_token/3 sets headers correctly" do
      Dwolla.Mock
      |> expect(:request, 1, fn :get, _, _, rh, _ ->
        content_type =
          Enum.find(rh, fn {k, _v} ->
            k == "Content-Type"
          end)

        assert {"Content-Type", "application/vnd.dwolla.v1.hal+json"} == content_type
        {:ok, httpoison_response(%{status: "ok"})}
      end)

      Dwolla.make_request_with_token(:get, "any", "token")
    end

    test "make_oauth_token_request/2 sets headers correctly" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, _, rh, _ ->
        content_type =
          Enum.find(rh, fn {k, _v} ->
            k == "Content-Type"
          end)

        assert {"Content-Type", "application/x-www-form-urlencoded"} == content_type
        {:ok, httpoison_response(%{status: "ok"})}
      end)

      Dwolla.make_oauth_token_request(%{}, %{client_id: "id", client_secret: "shhhh"})
    end

    test "make_request_with_token/3 makes payload camel case" do
      Dwolla.Mock
      |> expect(:request, 1, fn :post, _, rb, _, _ ->
        assert %{"firstName" => "Steve"} == Poison.decode!(rb)

        {:ok, httpoison_response("")}
      end)

      Dwolla.make_request_with_token(:post, "any", "token", %{first_name: "Steve"})
    end
  end

  defp cleanup_config do
    Application.put_env(:dwolla, :client_id, "my_client_id")
    Application.put_env(:dwolla, :client_secret, "my_client_secret")
  end
end
