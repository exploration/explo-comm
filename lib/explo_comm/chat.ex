defmodule ExploComm.Chat do
  @moduledoc """
  Just the Chat functions we need at EXPLO, ma'am. Nothing else. 
  """

  @doc """
  Send a notification message through a Chat URL.
  """
  @spec send_notification(String.t(), String.t()) ::
    {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_notification(message, url) do
    HTTPoison.post(url, body(message), headers())
  end

  defp body(message) do
    Poison.encode! %{ text: message }
  end

  defp headers() do
    [
      {"Content-Type", "application/json; charset=UTF-8"},
    ]
  end
end
