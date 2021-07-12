defmodule ExploComm.Mandrill do
  @moduledoc """
  The part of Mandrill that we want to use at EXPLO.

  Basically: sending messages as text, but wrapped in a nice HTML wrapper with a logo at the top.

  You'll need to set the following configuration keys to use this module:

      config :explo_comm,
        mandrill_api_key: "yer_key_here",
        mandrill_api_url: "https://mandrillapp.com/api/1.0/"
        mandrill_default_from: "EXPLO IT",
        mandrill_default_from_email: "it@explo.org"
  """

  alias ExploComm.Email

  @doc """
  Send an email through Mandrill using `ExploComm.Email` structs

  You build the email using an `ExploComm.Email` struct. The `to` key of that email should be a list of `ExploComm.Email.Recipient` structs.

  Returns the POST result from Mandrill, similar to the result of any `HTTPoison.post/4`

  ## Examples

      iex> ExploComm.Mandrill.send_email(%ExploComm.Email.{from_name: "Cardi", from_email: "cardib@cardi.com", to: [%ExploComm.Email.Recipient{name: "Eric", email: "Eric", type: "to"}, %ExploComm.Email.Recipient{name: "Jealous", email: "j@boyfriend.com", type: "bcc"}], subject: "It was nice seeing you after the show", body: "💋 Cardi"})
  """
  @spec send_email(Email.t()) :: ExploComm.response()
  def send_email(%Email{} = email) do
    body =
      Poison.encode!(%{
        key: api_key(),
        message: email
      })

    headers =
      [{"Content-Type", "application/json"}] ++
        Enum.map(email.headers, fn {k, v} -> {k, v} end)

    HTTPoison.post(endpoint(), body, headers)
  end

  @doc """
  (DEPRECATED) Send a text email message through Mandrill. 

  Expects a string message, and a list of emails in email_list.

  Returns the POST result from Mandrill, similar to the result of any `HTTPoison.post/4`

  You can include a keyword list of options. Available options include:

  - `:subject` (String) - The subject of the email
  - `:from` (String) - The name to put in the FROM field for the email

  ## Examples
    
      iex> Mandrill.send_email("Email Body", ["dmerand@explo.org"], subject: "Cool Email", from: "cooldudes@explo.org")
      {:ok, %HTTPoison.Response{}}
  """
  @spec send_email(String.t(), [String.t()], keyword()) :: ExploComm.response()
  def send_email(message, email_list, options \\ []) do
    body =
      Poison.encode!(%{
        key: api_key(),
        message: %{
          text: message,
          subject: Keyword.get(options, :subject) || "EXPLO Apps: Notification",
          from_name: Keyword.get(options, :from) || default_from(),
          from_email: Keyword.get(options, :from_email) || default_from_email(),
          to: parse_recipients(email_list)
        }
      })

    headers = [{"Content-Type", "application/json"}]

    HTTPoison.post(endpoint(), body, headers)
  end

  defp api_key() do
    Application.get_env(:explo_comm, :mandrill_api_key) ||
      raise """
      Missing configuration variable :explo_comm, :mandrill_api_key
      """
  end

  defp api_url() do
    Application.get_env(:explo_comm, :mandrill_api_url) ||
      "https://mandrillapp.com/api/1.0/"
  end

  defp default_from() do
    Application.get_env(:explo_comm, :mandrill_default_from) ||
      "EXPLO"
  end

  defp default_from_email() do
    Application.get_env(:explo_comm, :mandrill_default_from_email) ||
      "summer@explo.org"
  end

  defp endpoint, do: "#{api_url()}/messages/send.json"

  defp parse_recipients(email_list) do
    Enum.map(email_list, fn email -> %{email: email} end)
  end
end
