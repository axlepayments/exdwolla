defmodule Dwolla.TestUtils do
  @moduledoc """
  Test utility functions.
  """

  def httpoison_response(body, status_code \\ 200, headers \\ [])

  def httpoison_response("", status_code, headers) do
    %HTTPoison.Response{
      headers: headers,
      body: "",
      status_code: status_code
    }
  end

  def httpoison_response(body, status_code, headers) when is_binary(body) do
    %HTTPoison.Response{
      headers: headers,
      body: Poison.decode!(body),
      status_code: status_code
    }
  end

  def httpoison_response(body, status_code, headers) do
    %HTTPoison.Response{
      headers: headers,
      body: body,
      status_code: status_code
    }
  end

  def httpoison_error(reason) do
    %HTTPoison.Error{
      reason: reason
    }
  end
end
