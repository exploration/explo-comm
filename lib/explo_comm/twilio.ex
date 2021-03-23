defmodule ExploComm.Twilio do
  @moduledoc """
  Send an SMS through Twilio.

  There are some configuration options you can set for this module in `config.exs` as such:

      config :explo_comm,
        twilio_account_id: "account_id",
        twilio_api_token: "password",
        twilio_api_url: "https://api.twilio.com/2010-04-0",
        twilio_default_from: "+16178675309"
  """

  @doc """
  Format a phone number for Twilio.

  Strip the number of  all non-numeric characters, then prepend a `+1` unless
  there's already a `+`.

  This function isn't smart enough to know about international, so
  international numbers are hopefully formatted properly.
  """
  @spec format_phone(String.t()) :: String.t()
  def format_phone(number) do
    number = String.replace(number, ~r/[-.\/() ]/, "")

    case String.starts_with?(number, "+") do
      true ->
        number

      false ->
        case String.starts_with?(number, "1") do
          true -> "+" <> number
          false -> "+1" <> number
        end
    end
  end

  @doc """
  Send an SMS through Twilio. 

  This setup assumes that you have a messaging service configured,
  which will take care of populating the number that sends the
  message.

  ## Options

  The following keyword options are accepted:

  - `:from` (String) - The phone number sending the message. This should be a valid number on the account.

  ## Examples

      iex> Twilio.send_sms("my message", "6171234567")
      {:ok, %HTTPoison.Response{}}
  """
  @spec send_sms(String.t(), String.t(), keyword()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_sms(message, to, options \\ []) do
    from = Keyword.get(options, :from) || default_from()
    body = URI.encode_query(%{From: from, To: to, Body: message})
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    endpoint = "#{api_url()}/Accounts/#{account_id()}/Messages.json"
    options = [hackney: [basic_auth: {account_id(), api_token()}]]

    HTTPoison.post(endpoint, body, headers, options)
  end

  defp account_id() do
    Application.get_env(:explo_comm, :twilio_account_id) ||
      raise """
      Missing configuration variable :explo_comm, :twilio_account_id
      """
  end

  defp api_token() do
    Application.get_env(:explo_comm, :twilio_api_token) ||
      raise """
      Missing configuration variable :explo_comm, :twilio_api_token
      """
  end

  defp api_url() do
    Application.get_env(:explo_comm, :twilio_api_url) ||
      "https://api.twilio.com/2010-04-01"
  end

  defp default_from() do
    Application.get_env(:explo_comm, :twilio_default_from) ||
      "+14158539756"
  end
end
