defmodule ExploComm.Chat do

  @moduledoc """
  Just the Chat functions we need at EXPLO, ma'am. Nothing else. Note that by default, this library sends text messages to just one room in Stride.

  This library assumes a default chat room URL. You can send an alternate room URL if you wish. The default URL is set in the `:explo_comm
  :chat_default_url` configuration file, or the `CHAT_DEFAULT_URL` environment variable.
  """

  @doc """
  Send a notification message through Chat.
  """
  @spec send_notification(String.t()) ::
    {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_notification(message) do
    HTTPoison.post(api_url(), body(message), headers())
  end

  @doc """
  Send a notification message through Chat via a custom URL.
  """
  @spec send_notification(String.t(), String.t()) ::
    {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_notification(message, custom_url) do
    HTTPoison.post(custom_url, body(message), headers())
  end

  defp api_url() do
    System.get_env("CHAT_DEFAULT_URL") ||
    Application.get_env(:explo_comm, :chat_default_url)
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

