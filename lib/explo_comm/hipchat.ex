defmodule ExploComm.HipChat do

  @moduledoc """
  Just the HipChat functions we need at EXPLO, ma'am. Nothing else.

  You'll need to put your api token into the `:explo_comm :hipchat_api_token` key in
  `config.exs`, or alternatively set an environment variable for
  `HIPCHAT_API_TOKEN`. The same thing applies for `:explo_comm
  :hipchat_default_room` / `HIPCHAT_DEFAULT_ROOM` and `:explo_comm,
  :hipchat_api_url`.
  """

  @doc """
  Send a notification through HipChat.

  You can include a keyword list of options. Available options include:
  
  - `:from` (String) - The name of the sender
  - `:mentions` ([String]) - The HipChat mention names of people who should
  receive a notification
  - `:room` (Integer) - The ID of the room to which to post the message
  """
  def send_notification(message, options \\ []) do
    mentions = format_mentions(Keyword.get(options, :mentions, []))
    room = Keyword.get(options, :room) || default_room()

    body = Poison.encode! %{
      from: Keyword.get(options, :from) || "EXPLO",
      format: "text",
      notify: true,
      message: "#{mentions}#{message}"
    }
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_token()}"}
    ]
    endpoint = "#{api_url()}/room/#{room}/notification"

    HTTPoison.post(endpoint, body, headers)
  end


  defp api_token() do
    System.get_env("HIPCHAT_API_TOKEN") ||
    Application.get_env(:explo_comm, :hipchat_api_token)
  end

  defp api_url() do
    System.get_env("HIPCHAT_API_URL") ||
    Application.get_env(:explo_comm, :hipchat_api_url) ||
    "https://api.hipchat.com/v2"
  end

  defp default_room() do
    System.get_env("HIPCHAT_DEFAULT_ROOM") ||
    Application.get_env(:explo_comm, :hipchat_default_room) ||
    "143945"
  end

  defp format_mentions(mentions) when is_list(mentions) do
    mentions
    |> Enum.map(fn recipient -> "@#{recipient}" end)
    |> Enum.join(" ")
    |> String.replace_suffix("", " ")
  end
end

