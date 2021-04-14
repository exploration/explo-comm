# EXPLO Comm Utils

This repository holds EXPLO's communications libraries + functions, useful
across a wide range of projects.

Currently we have modules for sending notifications via Google Chat
(`ExploComm.Chat`), Mandrill (`ExploComm.Mandrill`), and Twilio
(`ExploComm.Twilio`).


## Installation

The package can be installed by adding `explo` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:explo_comm, git: "github.com:exploration/explo-comm.git"},
  ]
end
```

## Setup

If you use any of the messaging utility modules (eg. Chat/Mandrill/Twilio),
you'll very likely want to set the following config vars in your application:

    config :explo_comm,
      mandrill_api_key: "your key",
      mandrill_api_url: "https://mandrillapp.com/api/1.0/"
      mandrill_default_from: "default from name"
      mandrill_default_from_email: "default@email.com",

      twilio_account_id: "account_id",
      twilio_api_token: "password",
      twilio_api_url: "https://api.twilio.com/2010-04-0",
      twilio_default_from: "+16178675309"
