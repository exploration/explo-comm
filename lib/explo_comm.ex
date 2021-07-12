defmodule ExploComm do
  @moduledoc """
  Send messages using standard message protocols
  """

  alias ExploComm.{Email, Mandrill, Twilio}

  @type response ::
          {:ok,
           HTTPoison.Response.t()
           | HTTPoison.AsyncResponse.t()
           | HTTPoison.MaybeRedirect.t()}
          | {:error, HTTPoison.Error.t()}

  @doc """
  Send an email

  You build the email using an `ExploComm.Email` struct. The `to` key of an `ExploComm.Email` should be a list of `ExploComm.Email.Recipient` structs.

  ## Examples

      iex> ExploComm.send_email(%ExploComm.Email{from_name: "Cardi", from_email: "cardib@cardi.com", to: [%ExploComm.Email.Recipient{name: "Eric", email: "Eric", type: "to"}, %ExploComm.Email.Recipient{name: "Jealous", email: "j@boyfriend.com", type: "bcc"}], subject: "It was nice seeing you after the show", body: "💋 Cardi"})
  """
  @spec send_email(Email.t()) :: response
  def send_email(email) do
    Mandrill.send_email(email)
  end

  @doc """
  Send an SMS

  ## Options

  The following keyword options are accepted:

  - `:from` (String) - The phone number sending the message. This should be a valid number on the account.
  """
  @spec send_sms(String.t(), String.t(), list) :: response
  def send_sms(message, recipient, options \\ []) do
    Twilio.send_sms(message, recipient, options)
  end
end
