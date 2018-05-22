defmodule ExploComm.Stride do

  @moduledoc """
  Just the Stride functions we need at EXPLO, ma'am. Nothing else. Note that by default, this library sends text messages to just one room in Stride.

  You'll need to put your api token into the `:explo_comm :stride_api_token` key in
  `config.exs`, or alternatively set an environment variable for
  `STRIDE_API_TOKEN`. The same thing applies for `:explo_comm
  :stride_api_url` / `STRIDE_API_URL`.
  """

  @doc """
  Send a notification message through Stride.
  """
  @spec send_notification(String.t()) ::
    {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_notification(message) do
    body = Poison.encode! %{
      body: %{
        version: 1,
        type: "doc",
        content: [
          %{
            type: "paragraph",
            content: [
              %{
                type: "text",
                text: message
              }
            ]
          }
        ]
      }
    }
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_token()}"}
    ]
    HTTPoison.post(api_url(), body, headers)
  end

  defp api_token() do
    System.get_env("STRIDE_API_TOKEN") ||
    Application.get_env(:explo_comm, :stride_api_token)
  end

  defp api_url() do
    System.get_env("STRIDE_API_URL") ||
    Application.get_env(:explo_comm, :stride_api_url)
  end
end

