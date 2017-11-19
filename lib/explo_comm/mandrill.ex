defmodule ExploComm.Mandrill do
  @moduledoc """
  This is the part of Mandrill that we want to use at EXPLO.

  To make this work, you'll need to set an environment variable
  `MANDRILL_API_KEY` with your Mandrill... key. Alternatively if you're playing
  it fast + loose, you can put the key right in your `mix.config` as `:explo_comm
  :mandrill_api_key`.

  Other available configuration keys are:

      MANDRILL_API_URL
      MANDRILL_DEFAULT_FROM
      MANDRILL_DEFAULT_FROM_EMAIL
  """

  @doc """
  Send an email message through Mandrill. Expects a string message, and an
  array of emails in email_list.

  You can include a keyword list of options. Available options include:
  
  - `:subject` (String) - The subject of the email
  - `:from` (String) - The name to put in the FROM field for the email
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
    System.get_env("MANDRILL_API_KEY") ||
    Application.get_env(:explo_comm, :mandrill_api_key)
  end

  defp api_url() do
    System.get_env("MANDRILL_API_URL") ||
    Application.get_env(:explo_comm, :mandrill_api_url) || 
    "https://mandrillapp.com/api/1.0/"
  end

  defp default_from() do
    System.get_env("MANDRILL_DEFAULT_FROM") ||
    Application.get_env(:explo_comm, :mandrill_default_from) ||
    "EXPLO Robot"
  end

  defp default_from_email() do
    System.get_env("MANDRILL_DEFAULT_FROM_EMAIL") ||
    Application.get_env(:explo_comm, :mandrill_default_from_email) ||
    "it@explo.org"
  end

  defp parse_recipients(email_list) do
    Enum.map(email_list, fn email -> %{email: email} end)
  end
end

