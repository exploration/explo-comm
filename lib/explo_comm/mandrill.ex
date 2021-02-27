defmodule ExploComm.Mandrill do
  @moduledoc """
  The part of Mandrill that we want to use at EXPLO.

  Basically: sending messages as text, but wrapped in a nice HTML wrapper with a logo at the top.

  You'll need to set the following configuration keys to use this module:

      config ExploComm,
        mandrill_api_key: "yer_key_here",
        mandrill_api_url: "https://mandrillapp.com/api/1.0/"
        mandrill_default_from: "EXPLO IT",
        mandrill_default_from_email: "it@explo.org"
  """

  @doc """
  Send an email message through Mandrill. Expects a string message,
  and an array of emails in email_list.

  Returns the POST result from Mandrill, similar to the result of any `HTTPoison.post/4`

  You can include a keyword list of options. Available options include:
  
  - `:subject` (String) - The subject of the email
  - `:from` (String) - The name to put in the FROM field for the email

  ## Examples
    
      iex> Mandrill.send_email("Email Body", ["dmerand@explo.org"], subject: "Cool Email", from: "cooldudes@explo.org")
      {:ok, %HTTPoison.Response{}}
  """
  @spec send_email(String.t(), [String.t()], keyword()) ::
    {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def send_email(message, email_list, options \\ []) do
    body = Poison.encode! %{
      key: api_key(),
      message: %{
        text: message,
        subject: Keyword.get(options, :subject) || "EXPLO Apps: Notification",
        from_name: Keyword.get(options, :from) || default_from(),
        from_email: Keyword.get(options, :from_email) || default_from_email(),
        to: parse_recipients(email_list)
      }
    }

    headers = [{"Content-Type", "application/json"}]
    endpoint = "#{api_url()}/messages/send.json"

    HTTPoison.post(endpoint, body, headers)
  end


  defp api_key() do
    Application.get_env(ExploComm, :mandrill_api_key) ||
      raise """
      Missing configuration variable ExploComm, :mandrill_api_key
      """
  end

  defp api_url() do
    Application.get_env(ExploComm, :mandrill_api_url) || 
    "https://mandrillapp.com/api/1.0/"
  end

  defp default_from() do
    Application.get_env(ExploComm, :mandrill_default_from) ||
    "EXPLO Robot"
  end

  defp default_from_email() do
    Application.get_env(ExploComm, :mandrill_default_from_email) ||
    "it@explo.org"
  end

  defp parse_recipients(email_list) do
    Enum.map(email_list, fn email -> %{email: email} end)
  end
end

