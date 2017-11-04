defmodule ExploComm.Twilio do

  @moduledoc """
  This is basically a module for sending an SMS through Twilio, which is all we
  ever really want to do with Twilio.

  There are some configuration options you can set for this module, which can
  be set as `ALL_CAPS` environment variables, or in `config.exs` as such:

      config :explo_comm,
        twilio_account_id: "account_id",
        twilio_api_token: "password",
        twilio_api_url: "https://api.twilio.com/2010-04-0",
        twilio_default_from: "+16178675309"
  """

  @doc """
  Send an SMS through Twilio. This setup assumes that you have a messaging
  service configured, which will take care of populating the number that sends
  the message.
  """
  def send_sms(message, to, options \\ []) do
    from = Keyword.get(options, :from) || default_from()
    body = URI.encode_query %{
      "From": from,
      "To": to,
      "Body": message
    }
    headers = ["Content-Type": "application/x-www-form-urlencoded"]
    endpoint = "#{api_url()}/Accounts/#{account_id()}/Messages.json"
    options = [hackney: [basic_auth: {account_id(), api_token()}]]

    HTTPoison.post(endpoint, body, headers, options)
  end

  @doc """
  Given a phone number, format it for Twilio - strip all non-numeric
  characters, then prepend a +1 unless there's already a +.

  This function isn't smart enough to know about international, so
  international numbers are hopefully formatted properly.
  """
  def format_phone(number) do
    number = String.replace(number, ~r/[-.\/() ]/, "")
    case String.starts_with?(number, "+") do
      true -> number
      false ->
        case String.starts_with?(number, "1") do
          true -> "+" <> number
          false -> "+1" <> number
        end
    end
  end

  defp account_id() do
    System.get_env("TWILIO_ACCOUNT_ID") ||
    Application.get_env(:explo_comm, :twilio_account_id)
  end

  defp api_token() do
    System.get_env("TWILIO_API_TOKEN") ||
    Application.get_env(:explo_comm, :twilio_api_token)
  end

  defp api_url() do
    System.get_env("TWILIO_API_URL") ||
    Application.get_env(:explo_comm, :twilio_api_url) ||
    "https://api.twilio.com/2010-04-01"
  end

  defp default_from() do
    System.get_env("TWILIO_DEFAULT_FROM") ||
    Application.get_env(:explo_comm, :twilio_default_from) ||
    "+14158539756"
  end

end

