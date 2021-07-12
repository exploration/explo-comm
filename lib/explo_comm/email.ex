defmodule ExploComm.Email do
  @moduledoc """
  A struct to represent a generic email

  Inspired (not accidentally) by https://mailchimp.com/developer/transactional/api/messages/send-new-message/

  Note that the `to` key of that email should be an array of `ExploComm.Email.Recipient` structs.

  ## Examples

      %ExploComm.Email{from_name: "Cardi", from_email: "cardib@cardi.com", to: [%ExploComm.Email.Recipient{name: "Eric", email: "Eric"}], subject: "It was nice seeing you after the show", body: "💋 Cardi"}
  """

  @typedoc """
  An email, with one or more recipients, optional headers, and an optional text part.
  """
  @type t :: %__MODULE__{
          from_name: String.t(),
          from_email: String.t(),
          to: list(ExploComm.Email.Recipient.t()),
          headers: list(map),
          subject: String.t(),
          html: String.t(),
          text: String.t()
        }

  @enforce_keys [:from_email, :to, :subject, :html]
  defstruct [:from_name, :from_email, :to, :subject, :html, :text, headers: []]
end
