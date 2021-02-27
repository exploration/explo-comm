defmodule ExploComm.Chat do
  @moduledoc """
  Just the Chat functions we need at EXPLO, ma'am. Nothing else. 
  """

  @doc """
  Send a notification message through a Google Chat URL.

  Returns the result of `HTTPoison.post/4` to the given chat endpoint url.

  ## Examples
  
      iex> Chat.send_notification("neat", "https://chat.google.com/etc")
      {:ok, %HTTPoison.Response{}}
      
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
